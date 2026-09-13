import Foundation

struct PersistedRoastState: Codable {
    var accumulatedTime: TimeInterval
    var isRunning: Bool
    var startDate: Date?
    var splits: [SplitRecord]
}

enum RoastStateStore {
    private static let key = "com.hokke72.CoffeeRoastStopwatch.roastState"

    static func load() -> PersistedRoastState? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(PersistedRoastState.self, from: data)
    }

    static func save(_ state: PersistedRoastState) {
        guard let data = try? JSONEncoder().encode(state) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
