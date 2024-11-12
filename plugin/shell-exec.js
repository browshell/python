// plugin/shell-exec.js
class ShellExecutor {
  constructor() {
    this.ws = new WebSocket('ws://localhost:8081');
  }

  async executeCommand(command) {
    // Validate command
    if (!this.isCommandSafe(command)) {
      throw new Error('Command not allowed');
    }

    // Send to executor
    return await this.ws.send({
      type: 'SHELL_EXEC',
      command
    });
  }

  handleTextContent(text) {
    // Extract commands from content
    const commands = this.parseCommands(text);
    
    // Execute in sandbox
    commands.forEach(cmd => {
      this.executeCommand(cmd);
    });
  }
}
