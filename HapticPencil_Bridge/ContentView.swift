import SwiftUI

struct ContentView: View {
    @EnvironmentObject var hapticServer: HapticServer
    let hapticTypes: [HapticType] = HapticType.allCases

    var body: some View {
        VStack(spacing: 20) {
            Text("Haptic Feedback Tester")
                .font(.title)
                .padding(.top, 40)

            ForEach(hapticTypes) { type in
                Button(action: {
                    triggerHaptic(type: type)
                }) {
                    Text(type.rawValue.capitalized)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .onAppear {
            Task {
                do {
                    try await hapticServer.start()
                } catch {
                    print("Error starting HapticServer: \(error)")
                }
            }
        }
    }

    func triggerHaptic(type: HapticType) {
        switch type {
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.warning)
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.error)
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
}
