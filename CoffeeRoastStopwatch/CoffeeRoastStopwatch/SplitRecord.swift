import Foundation

struct SplitRecord: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let elapsedTime: TimeInterval
    let recordedAt: Date
}
