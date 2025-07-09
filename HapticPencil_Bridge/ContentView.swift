import SwiftUI

struct ContentView: View {
    @State private var serverStatus: String = "Stopped"
    @State private var serverAddress: String = "N/A"
    @State private var isServerRunning: Bool = false
    
    // Use @StateObject for reference types that you want to persist across view updates
    // and that conform to ObservableObject. HapticServer is not ObservableObject, so we'll just instantiate it.
    private let hapticServer = HapticServer()

    var body: some View {
        VStack {
            Text("HapticPencil Bridge")
                .font(.largeTitle)
                .padding()

            Spacer()

            Text("Server Status: \(serverStatus)")
                .font(.headline)
                .padding(.bottom, 5)

            Text("Address: \(serverAddress)")
                .font(.subheadline)
                .padding(.bottom, 20)

            Button(action: {
                Task {
                    if isServerRunning {
                        hapticServer.stop()
                        serverStatus = "Stopped"
                        serverAddress = "N/A"
                    } else {
                        serverStatus = "Starting..."
                        do {
                            let address = try await hapticServer.start()
                            serverAddress = address
                            serverStatus = "Running"
                        } catch {
                            serverStatus = "Failed to Start"
                            serverAddress = "Error"
                            print("Error starting server: \(error)")
                        }
                    }
                    isServerRunning.toggle()
                }
            }) {
                Text(isServerRunning ? "Stop Server" : "Start Server")
                    .font(.title2)
                    .padding()
                    .background(isServerRunning ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}