import SwiftUI

struct ServerControlView: View {
    let hapticTypes: [HapticType] = HapticType.watchOSCompatibleHaptics

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(hapticTypes) { type in
                    Button(action: {
                        HapticManager.trigger(type: type)
                        ConnectivityManager.shared.sendHaptic(type)
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
            }
            .padding(.vertical)
        }
    }
}
