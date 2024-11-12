export class CommandRunner {
  private sandbox: DockerSandbox;

  constructor() {
    this.sandbox = new DockerSandbox({
      image: 'browshell/shell-env:latest',
      timeout: 30000,
      maxMemory: '256m'
    });
  }

  async execute(command: string): Promise<ExecutionResult> {
    // Create new container for command
    const container = await this.sandbox.create();

    try {
      // Run command
      const result = await container.run(command);
      return result;
    } finally {
      // Cleanup
      await container.remove();
    }
  }
}
