
import Foundation
import WatchKit

struct HapticManager {
    static func trigger(type: HapticType) {
        let watchHapticType: WKHapticType
        switch type {
        case .notification:
            watchHapticType = .notification
        case .directionUp:
            watchHapticType = .directionUp
        case .directionDown:
            watchHapticType = .directionDown
        case .success:
            watchHapticType = .success
        case .failure:
            watchHapticType = .failure
        case .retry:
            watchHapticType = .retry
        case .start:
            watchHapticType = .start
        case .stop:
            watchHapticType = .stop
        case .click:
            watchHapticType = .click
        case .light, .medium, .heavy, .error, .selection, .warning:
            print("Haptic type \(type.rawValue) not supported on watchOS")
            return
        }
        WKInterfaceDevice.current().play(watchHapticType)
    }
}
