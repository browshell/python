# ./shell-api/Dockerfile

# Używamy oficjalnego obrazu Pythona
FROM python:3.11-slim

# Instalacja niezbędnych pakietów systemowych
RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    python3-dev \
    libffi-dev \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Utwórz i ustaw katalog roboczy
WORKDIR /app

# Skopiuj pliki wymagań i zainstaluj zależności
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Skopiuj kod aplikacji
COPY . .

# Utwórz użytkownika bez uprawnień roota
RUN useradd -m -u 1000 shellapi && \
    chown -R shellapi:shellapi /app

# Dodaj użytkownika do grupy docker
RUN usermod -aG docker shellapi

# Przełącz na użytkownika bez uprawnień roota
USER shellapi

# Expose port for API
EXPOSE 8000

# Uruchom aplikację używając uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
