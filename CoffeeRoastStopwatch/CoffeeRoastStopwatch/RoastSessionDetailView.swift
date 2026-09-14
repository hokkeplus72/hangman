import SwiftUI

struct RoastSessionDetailView: View {
    let session: RoastSession

    var body: some View {
        List {
            ForEach(Array(session.splits.enumerated()), id: \.element.id) { index, split in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(split.label)
                            .font(.headline)
                        if index > 0 {
                            let delta = split.elapsedTime - session.splits[index - 1].elapsedTime
                            Text("前回から +\(TimeFormatting.mainText(delta))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Text(TimeFormatting.mainText(split.elapsedTime))
                        .font(.system(.title3, design: .monospaced))
                        .fontWeight(.semibold)
                }
            }
        }
        .navigationTitle(session.startedAt.formatted(date: .abbreviated, time: .shortened))
    }
}
