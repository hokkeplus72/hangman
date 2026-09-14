import Foundation

struct RoastSession: Identifiable, Codable, Hashable {
    let id: UUID
    let startedAt: Date
    let finishedAt: Date
    let splits: [SplitRecord]

    init(id: UUID = UUID(), startedAt: Date, finishedAt: Date, splits: [SplitRecord]) {
        self.id = id
        self.startedAt = startedAt
        self.finishedAt = finishedAt
        self.splits = splits
    }
}
