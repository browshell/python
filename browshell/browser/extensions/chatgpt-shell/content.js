document.addEventListener('DOMContentLoaded', () => {
    // Find code blocks in ChatGPT responses
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            mutation.addedNodes.forEach((node) => {
                if (node.nodeType === 1) {
                    const codeBlocks = node.querySelectorAll('pre code');
                    codeBlocks.forEach(addExecuteButton);
                }
            });
        });
    });

    observer.observe(document.body, {
        childList: true,
        subtree: true
    });

    function addExecuteButton(codeBlock) {
        if (codeBlock.hasExecuteButton) return;

        const button = document.createElement('button');
        button.textContent = '▶ Execute';
        button.className = 'execute-code-btn';
        button.onclick = () => executeCode(codeBlock.textContent);

        codeBlock.parentElement.appendChild(button);
        codeBlock.hasExecuteButton = true;
    }

    async function executeCode(code) {
        try {
            const response = await fetch('http://shell-api:8000/execute', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    code: code,
                    language: detectLanguage(code)
                })
            });

            const result = await response.json();
            showResult(result);
        } catch (error) {
            showError(error);
        }
    }

    function showResult(result) {
        const resultDiv = document.createElement('div');
        resultDiv.className = 'code-execution-result';
        resultDiv.innerHTML = `
      <pre>${result.output}</pre>
    `;

        const lastCodeBlock = document.querySelector('pre code:last-of-type');
        lastCodeBlock.parentElement.after(resultDiv);
    }
});

// Styles for the extension
const styles = `
  .execute-code-btn {
    position: absolute;
    top: 5px;
    right: 5px;
    padding: 5px 10px;
    background: #4CAF50;
    color: white;
    border: none;
    border-radius: 3px;
    cursor: pointer;
  }

  .code-execution-result {
    margin: 10px 0;
    padding: 10px;
    background: #f5f5f5;
    border-left: 4px solid #4CAF50;
  }
`;
