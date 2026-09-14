import SwiftUI
import UniformTypeIdentifiers

struct RoastHistoryView: View {
    @State private var sessions: [RoastSession] = RoastHistoryStore.load()
    @State private var isExporting = false
    @State private var exportDocument: CSVDocument?

    private var sortedSessions: [RoastSession] {
        sessions.sorted { $0.startedAt > $1.startedAt }
    }

    var body: some View {
        Group {
            if sessions.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("記録がありません")
                        .font(.headline)
                    Text("焙煎を記録してリセットすると、ここに履歴が残ります")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
            } else {
                List {
                    ForEach(sortedSessions) { session in
                        NavigationLink(value: session) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(session.startedAt.formatted(date: .abbreviated, time: .shortened))
                                    .font(.headline)
                                Text("記録 \(session.splits.count)件")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
        }
        .navigationTitle("焙煎履歴")
        .navigationDestination(for: RoastSession.self) { session in
            RoastSessionDetailView(session: session)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    exportDocument = CSVDocument(text: CSVExporter.makeCSV(from: sessions))
                    isExporting = true
                } label: {
                    Label("CSV書き出し", systemImage: "square.and.arrow.up")
                }
                .disabled(sessions.isEmpty)
            }
        }
        .fileExporter(
            isPresented: $isExporting,
            document: exportDocument,
            contentType: .commaSeparatedText,
            defaultFilename: defaultFilename()
        ) { _ in }
        .onAppear { sessions = RoastHistoryStore.load() }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            RoastHistoryStore.delete(sortedSessions[index])
        }
        sessions = RoastHistoryStore.load()
    }

    private func defaultFilename() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return "roast_history_\(formatter.string(from: Date()))"
    }
}
