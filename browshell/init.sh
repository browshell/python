#!/bin/bash
# Tworzenie struktury katalogów i plików

# Tworzenie głównego katalogu
mkdir -p browser/extensions/chatgpt-shell

# Tworzenie plików konfiguracyjnych
cat > browser/supervisord.conf << 'EOL'
[supervisord]
nodaemon=true
user=root

[program:xvfb]
command=/usr/bin/Xvfb :99 -screen 0 %(ENV_VNC_RESOLUTION)s -ac
priority=0

[program:x11vnc]
command=/usr/bin/x11vnc -xkb -noxrecord -noxfixes -noxdamage -display :99 -forever -bg -rfbauth /home/chrome/.vnc/passwd -rfbport 5900
priority=1

[program:novnc]
command=/usr/share/novnc/utils/websockify/run --web /usr/share/novnc/lib 80 localhost:5900
priority=2

[program:chrome]
command=/usr/bin/chromium-browser --no-sandbox --load-extension=/usr/share/extensions --remote-debugging-port=9222 --start-maximized
environment=DISPLAY=:99
user=chrome
priority=3

[program:selenium]
command=python3 /home/chrome/selenium_server.py
environment=DISPLAY=:99
user=chrome
priority=4
EOL

# Tworzenie pliku startowego
cat > browser/startup.sh << 'EOL'
#!/bin/bash
mkdir -p /home/chrome/.vnc
x11vnc -storepasswd ${VNC_PASSWORD:-browsershell} /home/chrome/.vnc/passwd
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
EOL

# Nadawanie uprawnień wykonywania
chmod +x browser/startup.sh

# Tworzenie plików rozszerzenia Chrome
cat > browser/extensions/chatgpt-shell/manifest.json << 'EOL'
{
  "manifest_version": 3,
  "name": "ChatGPT Shell Executor",
  "version": "1.0",
  "permissions": [
    "activeTab",
    "scripting",
    "storage"
  ],
  "host_permissions": [
    "https://chat.openai.com/*"
  ],
  "content_scripts": [
    {
      "matches": ["https://chat.openai.com/*"],
      "js": ["content.js"],
      "css": ["styles.css"]
    }
  ]
}
EOL

cat > browser/extensions/chatgpt-shell/content.js << 'EOL'
document.addEventListener('DOMContentLoaded', () => {
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
});
EOL

cat > browser/extensions/chatgpt-shell/styles.css << 'EOL'
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
EOL

# Tworzenie pliku Dockerfile
cat > browser/Dockerfile << 'EOL'
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    python3 \
    python3-pip \
    xvfb \
    x11vnc \
    novnc \
    supervisor \
    chromium-browser \
    chromium-chromedriver \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    fonts-symbola \
    fonts-noto \
    fonts-freefont-ttf \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/chrome -s /bin/bash chrome
RUN usermod -aG sudo chrome
RUN echo "chrome ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

COPY supervisord.conf /etc/supervisor/conf.d/
COPY startup.sh /
COPY extensions/ /usr/share/extensions/

RUN mkdir -p /usr/share/novnc && \
    git clone https://github.com/novnc/noVNC.git /usr/share/novnc/lib && \
    git clone https://github.com/novnc/websockify /usr/share/novnc/utils/websockify && \
    ln -s /usr/share/novnc/lib/vnc.html /usr/share/novnc/index.html

RUN chown -R chrome:chrome /home/chrome
RUN chmod +x /startup.sh

USER chrome
WORKDIR /home/chrome

EXPOSE 80 5900 4444

CMD ["/startup.sh"]
EOL

echo "Struktura katalogów i pliki zostały utworzone pomyślnie."
