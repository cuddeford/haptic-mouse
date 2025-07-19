import SwiftUI

@main
struct HapticPencil_BridgeApp: App {
    @StateObject private var hapticServer = HapticServer()
    @StateObject private var connectivityManager = ConnectivityManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(hapticServer)
        }
    }
}
