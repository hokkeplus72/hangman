import Foundation

final class RoastTimerViewModel: ObservableObject {
    @Published private(set) var elapsedTime: TimeInterval = 0
    @Published private(set) var isRunning: Bool = false
    @Published private(set) var splits: [SplitRecord] = []

    private var timer: Timer?
    private var startDate: Date?
    private var accumulatedTime: TimeInterval = 0

    func start() {
        guard !isRunning else { return }
        startDate = Date()
        isRunning = true
        let timer = Timer(timeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
    }

    func pause() {
        guard isRunning else { return }
        timer?.invalidate()
        timer = nil
        if let startDate {
            accumulatedTime += Date().timeIntervalSince(startDate)
        }
        startDate = nil
        isRunning = false
        elapsedTime = accumulatedTime
    }

    func reset() {
        timer?.invalidate()
        timer = nil
        startDate = nil
        accumulatedTime = 0
        elapsedTime = 0
        isRunning = false
        splits.removeAll()
    }

    func recordSplit(label: String) {
        let record = SplitRecord(label: label, elapsedTime: elapsedTime, recordedAt: Date())
        splits.append(record)
    }

    func deleteSplit(_ record: SplitRecord) {
        splits.removeAll { $0.id == record.id }
    }

    private func tick() {
        guard let startDate else { return }
        elapsedTime = accumulatedTime + Date().timeIntervalSince(startDate)
    }
}
