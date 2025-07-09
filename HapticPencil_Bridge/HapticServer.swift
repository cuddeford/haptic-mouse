import Foundation
import Hummingbird
import HummingbirdFoundation

struct HapticRequest: Decodable {
    let type: HapticType
}

struct HapticResponse: Encodable {
    let status: String
    let message: String
}

class HapticServer {
    private var app: HBApplication?
    private let port: Int

    init(port: Int = 8080) {
        self.port = port
    }

    func start() async throws -> String {
        let router = HBRouter()

        router.post("/haptic") {
            request -> HBResponse in
            do {
                let hapticRequest = try request.decode(as: HapticRequest.self)
                HapticManager.shared.trigger(type: hapticRequest.type)
                let response = HapticResponse(status: "ok", message: "Haptic feedback of type '\(hapticRequest.type)' triggered.")
                return HBResponse(status: .ok, headers: ["Content-Type": "application/json"], body: .init(byteBuffer: try JSONEncoder().encodeAsByteBuffer(response)))
            } catch {
                let errorResponse = HapticResponse(status: "error", message: "Invalid haptic type provided or JSON decoding error: \(error.localizedDescription)")
                return HBResponse(status: .badRequest, headers: ["Content-Type": "application/json"], body: .init(byteBuffer: try JSONEncoder().encodeAsByteBuffer(errorResponse)))
            }
        }

        let configuration = HBApplication.Configuration(address: .hostname("0.0.0.0", port: port))
        app = HBApplication(configuration: configuration)
        app?.router = router

        Task {
            do {
                try await app?.start()
            } catch {
                print("Server failed to start: \(error)")
            }
        }
        
        // Attempt to get the local IP address
        if let ipAddress = getLocalIPAddress() {
            return "http://\(ipAddress):\(port)"
        } else {
            return "http://localhost:\(port) (IP not found)"
        }
    }

    func stop() {
        app?.stop()
        app = nil
    }
    
    private func getLocalIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
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
}
