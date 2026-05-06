import Network
import Foundation
import Darwin

final class HTTPServer: ObservableObject {
    static let shared = HTTPServer()

    @Published private(set) var isRunning = false
    let localIP: String
    let port: UInt16 = 8000

    private var listener: NWListener?

    private init() {
        self.localIP = HTTPServer.detectLocalIP()
    }

    var url: String { "http://\(localIP):\(port)" }

    func start() {
        let params = NWParameters.tcp
        params.allowLocalEndpointReuse = true

        guard let l = try? NWListener(using: params, on: NWEndpoint.Port(rawValue: port)!) else { return }
        listener = l

        l.newConnectionHandler = { [weak self] conn in self?.handle(conn) }
        l.stateUpdateHandler = { [weak self] state in
            DispatchQueue.main.async { self?.isRunning = (state == .ready) }
        }
        l.start(queue: .global(qos: .background))
    }

    private func handle(_ conn: NWConnection) {
        conn.start(queue: .global(qos: .background))
        conn.receive(minimumIncompleteLength: 1, maximumLength: 8192) { [weak self] data, _, _, _ in
            guard let self, let data, !data.isEmpty else { conn.cancel(); return }
            self.route(data: data, on: conn)
        }
    }

    private func route(data: Data, on conn: NWConnection) {
        guard let text = String(data: data, encoding: .utf8) else { conn.cancel(); return }
        let parts = (text.components(separatedBy: "\r\n").first ?? "").split(separator: " ")
        guard parts.count >= 2 else { conn.cancel(); return }

        let method = String(parts[0])
        let path   = String(parts[1])

        let response: Data
        switch (method, path) {
        case ("POST", "/next"):
            KeySender.next()
            response = jsonOK()
        case ("POST", "/prev"):
            KeySender.prev()
            response = jsonOK()
        case ("GET", "/"), ("GET", "/index.html"):
            response = serveHTML()
        default:
            response = http("404 Not Found", Data("Not found".utf8), "text/plain")
        }

        conn.send(content: response, completion: .contentProcessed { _ in conn.cancel() })
    }

    private func jsonOK() -> Data {
        http("200 OK", Data(#"{"ok":true}"#.utf8), "application/json")
    }

    private func serveHTML() -> Data {
        if let url = Bundle.main.url(forResource: "index", withExtension: "html"),
           let body = try? Data(contentsOf: url) {
            return http("200 OK", body, "text/html; charset=utf-8")
        }
        return http("404 Not Found", Data("index.html not found".utf8), "text/plain")
    }

    private func http(_ status: String, _ body: Data, _ type: String) -> Data {
        let header = "HTTP/1.1 \(status)\r\nContent-Type: \(type)\r\nContent-Length: \(body.count)\r\nConnection: close\r\n\r\n"
        var r = Data(header.utf8)
        r.append(body)
        return r
    }

    private static func detectLocalIP() -> String {
        let fd = Darwin.socket(AF_INET, SOCK_DGRAM, 0)
        guard fd >= 0 else { return "127.0.0.1" }
        defer { Darwin.close(fd) }

        var remote = sockaddr_in()
        remote.sin_len    = UInt8(MemoryLayout<sockaddr_in>.size)
        remote.sin_family = sa_family_t(AF_INET)
        remote.sin_port   = UInt16(53).bigEndian
        inet_pton(AF_INET, "8.8.8.8", &remote.sin_addr)

        let ok = withUnsafePointer(to: remote) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.connect(fd, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
        guard ok == 0 else { return "127.0.0.1" }

        var local = sockaddr_in()
        var len   = socklen_t(MemoryLayout<sockaddr_in>.size)
        withUnsafeMutablePointer(to: &local) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                _ = getsockname(fd, $0, &len)
            }
        }

        var buf = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
        inet_ntop(AF_INET, &local.sin_addr, &buf, socklen_t(INET_ADDRSTRLEN))
        return String(cString: buf)
    }
}
