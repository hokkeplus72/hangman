import Foundation

enum TimeFormatting {
    struct Components {
        let hours: Int
        let minutes: Int
        let seconds: Int
        let tenths: Int
    }

    static func components(_ time: TimeInterval) -> Components {
        let clamped = max(0, time)
        let totalTenths = Int((clamped * 10).rounded(.down))
        let tenths = totalTenths % 10
        let totalSeconds = totalTenths / 10
        let seconds = totalSeconds % 60
        let totalMinutes = totalSeconds / 60
        let minutes = totalMinutes % 60
        let hours = totalMinutes / 60
        return Components(hours: hours, minutes: minutes, seconds: seconds, tenths: tenths)
    }

    static func mainText(_ time: TimeInterval) -> String {
        let c = components(time)
        if c.hours > 0 {
            return String(format: "%d:%02d:%02d", c.hours, c.minutes, c.seconds)
        }
        return String(format: "%02d:%02d", c.minutes, c.seconds)
    }

    static func tenthsText(_ time: TimeInterval) -> String {
        ".\(components(time).tenths)"
    }
}
