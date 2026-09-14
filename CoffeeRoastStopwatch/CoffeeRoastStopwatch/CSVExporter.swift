import Foundation

enum CSVExporter {
    static func makeCSV(from sessions: [RoastSession]) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        var lines = ["焙煎日時,ラベル,経過時間(秒),経過時間"]
        for session in sessions.sorted(by: { $0.startedAt < $1.startedAt }) {
            let sessionDate = dateFormatter.string(from: session.startedAt)
            for split in session.splits {
                let seconds = String(format: "%.1f", split.elapsedTime)
                let formatted = TimeFormatting.mainText(split.elapsedTime)
                lines.append("\(field(sessionDate)),\(field(split.label)),\(seconds),\(formatted)")
            }
        }
        return lines.joined(separator: "\r\n")
    }

    private static func field(_ value: String) -> String {
        guard value.contains(",") || value.contains("\"") || value.contains("\n") else {
            return value
        }
        return "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
    }
}
