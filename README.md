# PPT Remote (macOS)

Un'applicazione nativa per macOS che trasforma il tuo smartphone in un telecomando per le presentazioni PowerPoint. 

A differenza della versione precedente in Python, questa è un'app nativa che vive nella barra dei menu, rileva automaticamente l'IP locale e genera un codice QR per una connessione istantanea.

## Caratteristiche

- **Nativa macOS**: Leggera e integrata nella barra dei menu (Menu Bar App).
- **Zero Configurazione**: Rileva automaticamente l'indirizzo IP della tua rete locale.
- **Connessione Rapida**: Genera un QR code da scansionare con il telefono per aprire subito l'interfaccia di controllo.
- **Web-Based**: Il telecomando funziona su qualsiasi browser (iOS, Android, Windows, ecc.) senza installare nulla sul telefono.
- **Sicura**: Richiede i permessi di Accessibilità standard di macOS per simulare i tasti freccia.

## Come Usare

1. **Scarica/Avvia**: Apri `PPTRemote.app` (disponibile nella cartella `build/`).
2. **Permessi**: Al primo avvio, macOS potrebbe richiedere l'accesso all'**Accessibilità**. Vai in `Impostazioni di Sistema > Privacy e Sicurezza > Accessibilità` e abilita `PPTRemote`.
3. **Connetti**: Clicca sull'icona nella barra dei menu, scansiona il QR code con il tuo telefono.
4. **Controlla**: Usa i bottoni "Avanti" e "Indietro" che appariranno sul browser del telefono per controllare la presentazione.

## Requisiti

- macOS 12.0 o superiore.
- PowerPoint (o qualsiasi software che risponda ai tasti freccia destra/sinistra).
- Il PC e il telefono devono essere sulla **stessa rete Wi-Fi**.

## Sviluppo

Il progetto è scritto in **Swift** utilizzando:
- **SwiftUI** per l'interfaccia della barra dei menu.
- **Network Framework** per il server HTTP leggero integrato.
- **CoreImage** per la generazione dinamica del QR Code.

### Struttura del Progetto
```
PPTRemote/
├── PPTRemoteApp.swift   # Entry point dell'app
├── MenuBarView.swift    # UI della barra dei menu e QR Code
├── HTTPServer.swift     # Server web e logica di rete
├── KeySender.swift      # Simulazione eventi tastiera (Quartz)
└── index.html           # Interfaccia web caricata dal telefono
```

## Installazione per Sviluppatori

1. Clona il repository.
2. Apri `PPTRemote.xcodeproj` con Xcode.
3. Build & Run (Cmd+R).
