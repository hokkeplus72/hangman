import Foundation

final class RoastTimerViewModel: ObservableObject {
    @Published private(set) var elapsedTime: TimeInterval = 0
    @Published private(set) var isRunning: Bool = false
    @Published private(set) var splits: [SplitRecord] = []

    private var startDate: Date?
    private var accumulatedTime: TimeInterval = 0
    private var sessionStartedAt: Date?

    init() {
        restore()
    }

    /// Elapsed time computed live from the stored start date, independent of any
    /// @Published property. Intended for a view (e.g. TimelineView) to poll on its
    /// own schedule without forcing this object's owner to re-render every tick.
    func currentElapsed() -> TimeInterval {
        guard let startDate else { return accumulatedTime }
        return accumulatedTime + Date().timeIntervalSince(startDate)
    }

    func start() {
        guard !isRunning else { return }
        if sessionStartedAt == nil {
            sessionStartedAt = Date()
        }
        startDate = Date()
        isRunning = true
        persist()
    }

    func pause() {
        guard isRunning else { return }
        if let startDate {
            accumulatedTime += Date().timeIntervalSince(startDate)
        }
        startDate = nil
        isRunning = false
        elapsedTime = accumulatedTime
        persist()
    }

    func reset() {
        let finalElapsed = currentElapsed()
        if let sessionStartedAt, finalElapsed > 0 || !splits.isEmpty {
            let session = RoastSession(startedAt: sessionStartedAt, finishedAt: Date(), splits: splits)
            RoastHistoryStore.append(session)
        }
        startDate = nil
        accumulatedTime = 0
        elapsedTime = 0
        isRunning = false
        splits.removeAll()
        sessionStartedAt = nil
        RoastStateStore.clear()
    }

    func recordSplit(label: String) {
        let record = SplitRecord(label: label, elapsedTime: currentElapsed(), recordedAt: Date())
        splits.append(record)
        persist()
    }

    func deleteSplit(_ record: SplitRecord) {
        splits.removeAll { $0.id == record.id }
        persist()
    }

    private func persist() {
        let state = PersistedRoastState(
            accumulatedTime: accumulatedTime,
            isRunning: isRunning,
            startDate: startDate,
            splits: splits,
            sessionStartedAt: sessionStartedAt
        )
        RoastStateStore.save(state)
    }

    private func restore() {
        guard let state = RoastStateStore.load() else { return }
        accumulatedTime = state.accumulatedTime
        splits = state.splits
        sessionStartedAt = state.sessionStartedAt
        if state.isRunning, let restoredStartDate = state.startDate {
            startDate = restoredStartDate
            isRunning = true
        } else {
            elapsedTime = accumulatedTime
        }
    }
}
