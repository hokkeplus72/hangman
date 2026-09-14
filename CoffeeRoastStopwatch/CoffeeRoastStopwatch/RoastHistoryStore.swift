import Foundation

enum RoastHistoryStore {
    private static let key = "com.hokke72.CoffeeRoastStopwatch.roastHistory"

    static func load() -> [RoastSession] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([RoastSession].self, from: data)) ?? []
    }

    static func append(_ session: RoastSession) {
        var sessions = load()
        sessions.append(session)
        save(sessions)
    }

    static func delete(_ session: RoastSession) {
        var sessions = load()
        sessions.removeAll { $0.id == session.id }
        save(sessions)
    }

    private static func save(_ sessions: [RoastSession]) {
        guard let data = try? JSONEncoder().encode(sessions) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
