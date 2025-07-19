import SwiftUI

struct ContentView: View {
    @StateObject var connectivityManager = ConnectivityManager.shared
    @StateObject var workoutManager = WorkoutManager()

    var body: some View {
        VStack {
            Text("Workout: \(workoutManager.workoutRunning ? "Active" : "Inactive")")
                .foregroundColor(workoutManager.workoutRunning ? .green : .red)
                .font(.headline)
                .padding()

            Button(action: {
                if workoutManager.workoutRunning {
                    workoutManager.stopWorkout()
                } else {
                    workoutManager.startWorkout()
                }
            }) {
                Text(workoutManager.workoutRunning ? "Stop Workout" : "Start Workout")
                    .padding()
                    .background(workoutManager.workoutRunning ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Text("Last Haptic: \(connectivityManager.receivedHapticType?.rawValue ?? "None")")
                .padding()
        }
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

#Preview {
    ContentView()
}