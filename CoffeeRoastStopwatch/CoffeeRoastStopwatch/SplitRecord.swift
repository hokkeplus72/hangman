import Foundation

struct SplitRecord: Identifiable, Codable, Hashable {
    let id: UUID
    let label: String
    let elapsedTime: TimeInterval
    let recordedAt: Date

    init(id: UUID = UUID(), label: String, elapsedTime: TimeInterval, recordedAt: Date) {
        self.id = id
        self.label = label
        self.elapsedTime = elapsedTime
        self.recordedAt = recordedAt
    }
}
