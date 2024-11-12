class ShellCommandDetector {
    constructor() {
        this.ws = new WebSocket('ws://localhost:8081');
        this.setupListeners();
    }

    setupListeners() {
        document.addEventListener('selectionchange', () => {
            const selection = document.getSelection().toString();
            if (this.isShellCommand(selection)) {
                this.handleCommand(selection);
            }
        });
    }

    isShellCommand(text) {
        // Logika wykrywania komend shell
        const shellPatterns = [
            /^\s*\$\s+.+/,
            /^\s*>\s+.+/,
            /^\s*#\s+.+/
        ];
        return shellPatterns.some(pattern => pattern.test(text));
    }

    async handleCommand(command) {
        try {
            await this.ws.send(JSON.stringify({
                type: 'SHELL_COMMAND',
                command: command.replace(/^\s*[$>#]\s+/, '')
            }));
        } catch (error) {
            console.error('Failed to send command:', error);
        }
    }
}

new ShellCommandDetector();
