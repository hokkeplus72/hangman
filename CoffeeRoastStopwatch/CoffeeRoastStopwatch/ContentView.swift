import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var viewModel = RoastTimerViewModel()
    @State private var showResetConfirmation = false

    private let splitDefinitions: [(label: String, color: Color)] = [
        ("1ハゼ", .orange),
        ("2ハゼ", .red),
        ("焙煎終了", .brown)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                timerDisplay
                controlButtons
                Divider()
                splitButtons
                splitList
            }
            .padding()
            .navigationTitle("焙煎タイマー")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var timerDisplay: some View {
        HStack(alignment: .lastTextBaseline, spacing: 2) {
            Text(TimeFormatting.mainText(viewModel.elapsedTime))
                .font(.system(size: 84, weight: .bold, design: .monospaced))
                .minimumScaleFactor(0.4)
                .lineLimit(1)
            Text(TimeFormatting.tenthsText(viewModel.elapsedTime))
                .font(.system(size: 30, weight: .semibold, design: .monospaced))
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("経過時間 \(TimeFormatting.mainText(viewModel.elapsedTime))")
    }

    private var controlButtons: some View {
        HStack(spacing: 16) {
            Button(action: toggleStartPause) {
                Text(viewModel.isRunning ? "一時停止" : "スタート")
                    .font(.system(size: 26, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 76)
            }
            .buttonStyle(.borderedProminent)
            .tint(viewModel.isRunning ? .orange : .green)

            Button(action: { showResetConfirmation = true }) {
                Text("リセット")
                    .font(.system(size: 26, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 76)
            }
            .buttonStyle(.bordered)
            .tint(.red)
        }
        .confirmationDialog("記録をリセットしますか?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
            Button("リセット", role: .destructive) {
                viewModel.reset()
            }
            Button("キャンセル", role: .cancel) {}
        }
    }

    private var splitButtons: some View {
        VStack(spacing: 12) {
            ForEach(splitDefinitions, id: \.label) { def in
                Button(action: { recordSplit(def.label) }) {
                    Text(def.label)
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                }
                .buttonStyle(.borderedProminent)
                .tint(def.color)
                .disabled(!viewModel.isRunning && viewModel.elapsedTime == 0)
            }
        }
    }

    private var splitList: some View {
        List {
            let reversedSplits = Array(viewModel.splits.enumerated().reversed())
            ForEach(reversedSplits, id: \.element.id) { index, split in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(split.label)
                            .font(.headline)
                        if index > 0 {
                            let delta = split.elapsedTime - viewModel.splits[index - 1].elapsedTime
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
                .swipeActions {
                    Button("削除", role: .destructive) {
                        viewModel.deleteSplit(split)
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    private func toggleStartPause() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        if viewModel.isRunning {
            viewModel.pause()
        } else {
            viewModel.start()
        }
    }

    private func recordSplit(_ label: String) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        viewModel.recordSplit(label: label)
    }
}

#Preview {
    ContentView()
}
