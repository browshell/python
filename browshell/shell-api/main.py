from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import docker
import asyncio
from typing import Optional
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class CodeExecution(BaseModel):
    code: str
    language: str
    timeout: Optional[int] = 30

app = FastAPI()
client = docker.from_env()

LANGUAGE_CONFIGS = {
    "python": {
        "image": "python:3.11-slim",
        "command": ["python", "-c"],
        "file_ext": ".py"
    },
    "javascript": {
        "image": "node:18-slim",
        "command": ["node", "-e"],
        "file_ext": ".js"
    },
    "bash": {
        "image": "ubuntu:22.04",
        "command": ["bash", "-c"],
        "file_ext": ".sh"
    }
}

@app.post("/execute")
async def execute_code(execution: CodeExecution):
    try:
        if execution.language not in LANGUAGE_CONFIGS:
            raise HTTPException(status_code=400, detail="Unsupported language")

        config = LANGUAGE_CONFIGS[execution.language]
        
        container = client.containers.run(
            image=config["image"],
            command=[*config["command"], execution.code],
            detach=True,
            remove=True,
            mem_limit="100m",
            cpu_quota=50000,
            network_mode="none",
            security_opt=["no-new-privileges"],
            cap_drop=["ALL"],
        )

        try:
            result = await asyncio.wait_for(
                asyncio.get_event_loop().run_in_executor(
                    None,
                    container.wait
                ),
                timeout=execution.timeout
            )
            
            logs = container.logs().decode()
            return {
                "status": result["StatusCode"],
                "output": logs
            }
            
        except asyncio.TimeoutError:
            container.kill()
            raise HTTPException(
                status_code=408,
                detail="Execution timeout"
            )
            
    except Exception as e:
        logger.error(f"Error executing code: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )

@app.get("/health")
async def health_check():
    return {"status": "healthy"}
