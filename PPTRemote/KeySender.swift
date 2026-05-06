import CoreGraphics
import ApplicationServices

enum KeySender {
    static func next() { post(keyCode: 124) }
    static func prev() { post(keyCode: 123) }

    private static func post(keyCode: CGKeyCode) {
        guard AXIsProcessTrusted() else { return }
        let src = CGEventSource(stateID: .hidSystemState)
        CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)?.post(tap: .cgSessionEventTap)
        CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)?.post(tap: .cgSessionEventTap)
    }
}
