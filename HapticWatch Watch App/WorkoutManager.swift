import Foundation
import HealthKit

class WorkoutManager: NSObject, HKWorkoutSessionDelegate, ObservableObject {
    let healthStore = HKHealthStore()
    var workoutSession: HKWorkoutSession?

    @Published var workoutRunning = false

    func requestAuthorization() {
        let typesToShare: Set = [
            HKObjectType.workoutType()
        ]

        let typesToRead: Set = [
            HKObjectType.workoutType()
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if !success {
                print("Error requesting HealthKit authorization: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other
        configuration.locationType = .unknown

        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            workoutSession?.delegate = self
            workoutSession?.startActivity(with: Date())
            workoutRunning = true
        } catch {
            print("Error starting workout session: \(error.localizedDescription)")
        }
    }

    func stopWorkout() {
        workoutSession?.end()
        workoutSession = nil
        workoutRunning = false
    }

    // MARK: - HKWorkoutSessionDelegate

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            switch toState {
            case .running:
                self.workoutRunning = true
            case .ended, .stopped:
                self.workoutRunning = false
            default:
                break
            }
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed with error: \(error.localizedDescription)")
    }
}
