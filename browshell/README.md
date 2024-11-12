To rozwiązanie oparte o noVNC i Selenium z przeglądarką Chrome, wraz z pluginem do wykonywania kodu z ChatGPT.

1. Struktura katalogów:
```
.
├── browser/
│   ├── extensions/
│   │   └── chatgpt-shell/
│   │       ├── manifest.json
│   │       ├── content.js
│   │       └── styles.css
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── supervisord.conf
│   └── startup.sh
├── shell-api/
│   ├── Dockerfile
│   ├── requirements.txt
│   └── main.py
└── docker-compose.yml
```

2. Uruchom system:
```bash
docker-compose up --build
```

3. Dostęp do wirtualnej przeglądarki:
- Otwórz http://localhost:6080 w swojej przeglądarce
- Zaloguj się używając hasła: browsershell
- W wirtualnej przeglądarce przejdź do chat.openai.com

Funkcjonalności:
1. Wirtualna przeglądarka dostępna przez HTTP
2. Chrome z zainstalowanym pluginem
3. Bezpieczne wykonywanie kodu w izolowanych kontenerach
4. Wsparcie dla Python, JavaScript i Bash
5. Limity czasowe i zasobów dla wykonywanego kodu

Zabezpieczenia:
1. Izolacja przeglądarki w kontenerze
2. Ograniczone uprawnienia dla wykonywanych kontenerów
3. Limity zasobów
4. Brak dostępu do sieci dla wykonywanych skryptów

Możliwe rozszerzenia:
1. Dodanie większej liczby języków programowania
2. Zapisywanie historii wykonań
3. Udostępnianie wyników
4. Dodanie debuggera
5. Integracja z innymi narzędziami

