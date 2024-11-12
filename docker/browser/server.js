const express = require('express');
const WebSocket = require('ws');
const { spawn } = require('child_process');

const app = express();
const wss = new WebSocket.Server({ port: 8081 });

// Obsługa WebSocket
wss.on('connection', (ws) => {
    ws.on('message', async (message) => {
        try {
            const { command } = JSON.parse(message);
            const result = await executeCommand(command);
            ws.send(JSON.stringify({ success: true, result }));
        } catch (error) {
            ws.send(JSON.stringify({ success: false, error: error.message }));
        }
    });
});

// Funkcja wykonująca komendę
function executeCommand(command) {
    return new Promise((resolve, reject) => {
        const process = spawn('sh', ['-c', command]);
        let output = '';

        process.stdout.on('data', (data) => {
            output += data.toString();
        });

        process.stderr.on('data', (data) => {
            output += data.toString();
        });

        process.on('close', (code) => {
            if (code === 0) {
                resolve(output);
            } else {
                reject(new Error(`Command failed with code ${code}: ${output}`));
            }
        });
    });
}

app.listen(3000, () => {
    console.log('Server running on port 3000');
});
