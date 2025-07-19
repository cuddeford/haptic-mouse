import Foundation

#if os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#endif

struct HapticManager {
    static func trigger(type: HapticType) {
        #if os(iOS)
        // iOS-specific haptics
        switch type {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .notification, .directionUp, .directionDown, .failure, .retry, .start, .stop, .click:
            // These haptic types are primarily for watchOS and don't have direct iOS equivalents
            // We can choose to do nothing or map them to a generic iOS haptic if desired.
            // For now, we'll do nothing to avoid unexpected haptics on iOS.
            break
        }
        #elseif os(watchOS)
        // watchOS-specific haptics
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
        default:
            print("Haptic type \(type.rawValue) not supported on watchOS")
            return
        }
        WKInterfaceDevice.current().play(watchHapticType)
        #endif
    }
}
