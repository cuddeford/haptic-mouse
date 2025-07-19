import SwiftUI

struct ContentView: View {
    @EnvironmentObject var hapticServer: HapticServer
    @State private var serverIsRunning = false
    @State private var logs: [String] = []

    var body: some View {
        VStack {
            Text("Haptic Bridge Server")
                .font(.largeTitle)
                .padding()

            Text("IP: \(hapticServer.getIPAddress())")
                .font(.headline)

            Text("Status: \(serverIsRunning ? "Running" : "Stopped")")
                .font(.headline)
                .foregroundColor(serverIsRunning ? .green : .red)

            Button(action: {
                if serverIsRunning {
                    hapticServer.stop()
                    serverIsRunning = false
                    logs.append("Server stopped.")
                } else {
                    Task {
                        do {
                            try await hapticServer.start()
                            serverIsRunning = true
                            logs.append("Server started.")
                        } catch {
                            logs.append("Error starting server: \(error.localizedDescription)")
                        }
                    }
                }
            }) {
                Text(serverIsRunning ? "Stop Server" : "Start Server")
                    .font(.title2)
                    .padding()
                    .background(serverIsRunning ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            List(logs, id: \.self) {
                log in Text(log)
            }
            .frame(height: 200)

            ServerControlView()
        }
        .padding()
    }
}