# PPT Remote for macOS 🍎
<p align="center">
  <img src="asset/logo.png" width="150" alt="PPT Remote Logo">
</p>



<p align="center">
  <img src="https://img.shields.io/badge/Platform-macOS-black?style=for-the-badge&logo=apple" />
  <img src="https://img.shields.io/badge/Language-Swift-orange?style=for-the-badge&logo=swift" />
  <img src="https://img.shields.io/badge/Framework-SwiftUI-blue?style=for-the-badge&logo=swift" />
</p>

---

## 💡 Why This Project?
This tool was born from a practical need: creating a reliable presentation clicker for friends and professors that was **trivial to distribute**. 

Unlike Python-based alternatives, this native Swift application requires no runtime environment or dependencies. I focused heavily on **Zero-Configuration UX**—specifically solving the "Dynamic IP" problem. Since most users don't have static IPs, the app handles network discovery automatically, making it accessible even to non-technical users.

## ✨ Key Features
- **Native Menu Bar Integration**: Lives quietly in your status bar for quick access.
- **Zero-Config Connection**: Automatically detects your local IP and generates a dynamic QR code.
- **Cross-Platform Remote**: Control your presentation from any iOS, Android, or Windows Mobile device through a standard browser.
- **HID Simulation**: Leverages macOS Accessibility APIs to simulate physical arrow key presses.
- **Low Latency**: Optimized for instant response times over local Wi-Fi.

## 🛠 Technical Deep Dive
For recruiters and developers, this project showcases:

1. **Embedded HTTP Server**: Built using Apple's `Network` framework (`NWListener`). It handles incoming POST requests to trigger slide changes via a lightweight protocol.
2. **Dynamic Network Discovery (Key Feature)**: Most home and university networks use dynamic IPs. I implemented a robust UDP-based discovery logic that identifies the active interface's IP in real-time, ensuring the generated QR code works instantly on any network.
3. **CoreGraphics HID Simulation**: Leverages `Quartz` events to simulate physical arrow key presses at the system level.
4. **macOS Security Model**: While Accessibility permissions are a one-time mandatory step in macOS's security model, the app gracefully checks `AXIsProcessTrusted()` to provide a clear setup flow for the user.

## 📦 Project Structure
```text
PPTRemote/
├── PPTRemoteApp.swift   # App entry point & Lifecycle management
├── MenuBarView.swift    # SwiftUI-based Menu Bar UI & QR Generation
├── HTTPServer.swift     # Custom NWListener implementation (No dependencies)
├── KeySender.swift      # Quartz event simulation logic
└── index.html           # Mobile-optimized remote interface
```

## 🛠 How to Use
1. **Launch**: Open `PPTRemote.app` from the build folder.
2. **Permissions**: On first run, enable **Accessibility** permissions in `System Settings > Privacy & Security` (required to simulate key presses).
3. **Connect**: Click the menu bar icon and scan the QR code with your phone.
4. **Present**: Tap "Next" or "Prev" on your phone to control your slides.

## 🚀 Roadmap & Future Ideas
The current version focuses on simplicity, but the architecture allows for easy expansion:
- **Custom Macros**: Support for custom key combinations (e.g., volume control, window switching).
- **Presentation Timer**: Display a countdown timer on the mobile interface.
- **Multiple App Support**: Tailored layouts for Keynote, PDF viewers, and web-based slide decks.

---
*Developed with ❤️ by Flavio De Musso*

