chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.type === 'SHELL_COMMAND') {
        // Obsługa komendy
        executeCommand(request.command)
            .then(result => sendResponse({ success: true, result }))
            .catch(error => sendResponse({ success: false, error: error.message }));
        return true;
    }
});

async function executeCommand(command) {
    const response = await fetch('http://localhost:8082/execute', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ command })
    });
    return await response.json();
}
