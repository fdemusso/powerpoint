import SwiftUI
import ApplicationServices

@main
struct PPTRemoteApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        MenuBarExtra("PPT Remote", systemImage: "play.rectangle.fill") {
            MenuBarView()
                .environmentObject(HTTPServer.shared)
        }
        .menuBarExtraStyle(.window)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        _ = AXIsProcessTrustedWithOptions(
            ["AXTrustedCheckOptionPrompt": true] as CFDictionary
        )
        HTTPServer.shared.start()
    }
}
