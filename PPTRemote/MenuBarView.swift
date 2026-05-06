import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct MenuBarView: View {
    @EnvironmentObject private var server: HTTPServer

    var body: some View {
        VStack(spacing: 12) {
            if server.isRunning {
                qrView
                Text(server.url)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
                    .textSelection(.enabled)
            } else {
                ProgressView()
                Text("Avvio server…")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Divider()
            Button("Esci") { NSApp.terminate(nil) }
                .keyboardShortcut("q")
                .padding(.bottom, 4)
        }
        .padding(16)
        .frame(width: 210)
    }

    @ViewBuilder
    private var qrView: some View {
        if let img = makeQR(server.url) {
            Image(nsImage: img)
                .interpolation(.none)
                .resizable()
                .frame(width: 168, height: 168)
        }
    }

    private func makeQR(_ string: String) -> NSImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"
        guard let ci = filter.outputImage else { return nil }
        let scaled = ci.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        let rep = NSCIImageRep(ciImage: scaled)
        let img = NSImage(size: rep.size)
        img.addRepresentation(rep)
        return img
    }
}
