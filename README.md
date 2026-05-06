# PPT Remote

Telecomando web per PowerPoint. Gira sul PC con la presentazione, si controlla da qualsiasi dispositivo nella rete locale (telefono, tablet, altro PC).

## Come funziona

- Backend Python espone due endpoint HTTP (`/next`, `/prev`)
- Quando premi un bottone sul browser, il server simula la pressione della freccia destra/sinistra sulla macchina host
- Il frontend è ottimizzato per mobile con due grandi bottoni touch

## Requisiti

- Python 3.8+
- pip

## Installazione

```bash
pip install -r requirements.txt
```

## Avvio

```bash
python server.py
```

Il server parte su `http://0.0.0.0:8000` — visibile a tutti i dispositivi nella rete locale.

## Accesso

**Stesso PC:**
```
http://localhost:8000
```

**Altri dispositivi (telefono, tablet):**

Trova prima l'IP del PC host:

**macOS / Linux:**
```bash
ipconfig getifaddr en0
# oppure
hostname -I
```

**Windows:**
```cmd
ipconfig
# cerca "IPv4 Address" sotto la scheda di rete attiva
```

Poi apri sul dispositivo remoto:
```
http://<IP-del-pc>:8000
```

## Permessi OS

### macOS
`pyautogui` richiede accesso Accessibilità:

System Settings → Privacy & Security → **Accessibility** → aggiungi Terminal (o l'app da cui lanci Python)

### Windows
Nessun permesso extra richiesto. Assicurati che il firewall di Windows consenta connessioni in entrata sulla porta 8000:

```
Pannello di controllo → Windows Defender Firewall → Regole connessioni in entrata → Nuova regola → Porta 8000 → Consenti
```

Oppure al primo avvio Windows chiederà automaticamente se consentire l'accesso alla rete — clicca **Consenti**.

## Struttura

```
powerpoint/
├── server.py          # FastAPI backend + simulazione tasti
├── requirements.txt   # Dipendenze Python
└── static/
    └── index.html     # Frontend mobile-first
```

## Dipendenze

| Pacchetto | Scopo |
|-----------|-------|
| `fastapi` | Web framework |
| `uvicorn` | Server ASGI |
| `pyautogui` | Simulazione tasti |
