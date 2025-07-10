import Vapor
import Foundation
import Network
import Network
import NIOSSL

struct HapticRequest: Decodable {
    let type: HapticType
}

class HapticServer: ObservableObject {
    var app: Application
    private var ipAddress: String? {
        var address: String? = nil
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    if let name = interface?.ifa_name, String(cString: name) == "en0" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!),
                                    &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }

    init() {
        self.app = Application()
        app.http.server.configuration.hostname = "0.0.0.0"
        app.http.server.configuration.port = 8080

        // Configure CORS middleware
        let corsConfiguration = CORSMiddleware.Configuration(
            allowedOrigin: .all,
            allowedMethods: [.GET, .POST, .PUT, .PATCH, .DELETE, .OPTIONS],
            allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
        )
        let cors = CORSMiddleware(configuration: corsConfiguration)
        app.middleware.use(cors)

        self.setupRoutes()
    }

    func setupRoutes() {
        app.post("haptic") { req -> HTTPStatus in
            let hapticRequest = try req.content.decode(HapticRequest.self)
            HapticManager.trigger(type: hapticRequest.type)
            return .ok
        }
    }

    func start() async throws {
        app.http.server.configuration.tlsConfiguration = .makeServerConfiguration(
            certificateChain: try NIOSSL.NIOSSLCertificate.fromPEMFile(Bundle.main.path(forResource: "server", ofType: "crt")!).map { .certificate($0) },
            privateKey: .privateKey(try NIOSSL.NIOSSLPrivateKey(file: Bundle.main.path(forResource: "server", ofType: "key")!, format: .pem))
        )
        try await app.run()
    }

    func stop() {
        app.shutdown()
    }

    func getIPAddress() -> String {
        return ipAddress ?? "Unknown IP"
    }
}
