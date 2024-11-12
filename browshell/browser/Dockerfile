FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
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

# Set up user
RUN useradd -m -d /home/chrome -s /bin/bash chrome
RUN usermod -aG sudo chrome
RUN echo "chrome ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Python dependencies
COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

# Copy configurations
COPY supervisord.conf /etc/supervisor/conf.d/
COPY startup.sh /

# Copy extension
COPY extensions/ /usr/share/extensions/

# Set up noVNC
RUN mkdir -p /usr/share/novnc && \
    git clone https://github.com/novnc/noVNC.git /usr/share/novnc/lib && \
    git clone https://github.com/novnc/websockify /usr/share/novnc/utils/websockify && \
    ln -s /usr/share/novnc/lib/vnc.html /usr/share/novnc/index.html

# Set permissions
RUN chown -R chrome:chrome /home/chrome
RUN chmod +x /startup.sh

# Switch to chrome user
USER chrome
WORKDIR /home/chrome

# Expose ports
EXPOSE 80 5900 4444

# Start supervisord
CMD ["/startup.sh"]
