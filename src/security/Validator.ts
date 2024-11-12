export class CommandValidator {
  private allowedCommands: Set<string>;

  constructor() {
    this.allowedCommands = new Set([
      'ls', 'cat', 'echo', 'grep',
      'git', 'npm', 'node'
    ]);
  }

  validate(command: string): ValidationResult {
    // Parse command
    const [baseCmd] = command.split(' ');

    // Check if allowed
    if (!this.allowedCommands.has(baseCmd)) {
      return {
        valid: false,
        reason: 'Command not in allowlist'
      };
    }

    // Validate arguments
    return this.validateArgs(command);
  }
}
