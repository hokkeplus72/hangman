# 焙煎タイマー (Coffee Roast Stopwatch)

珈琲豆の焙煎時間を計測するiPhoneアプリ。スプリットタイム機能付き。

## 機能

- 大きな文字盤のストップウォッチ（スタート / 一時停止 / リセット）
- スプリットボタン：「1ハゼ」「2ハゼ」「焙煎終了」を押すとその時点の経過時間を記録
- 記録一覧に各イベントの経過時間と直前のイベントからの差分を表示
- 記録はスワイプで削除可能
- 大きい文字・大きいボタンで焙煎中の操作を容易に
- ボタン操作時にハプティックフィードバック

## 開くには

`CoffeeRoastStopwatch.xcodeproj` をXcodeで開き、iPhoneシミュレータまたは実機でビルド・実行してください（iOS 16.0以降）。

## ファイル構成

- `CoffeeRoastStopwatchApp.swift` — アプリのエントリポイント
- `ContentView.swift` — メイン画面（UI）
- `RoastTimerViewModel.swift` — タイマーとスプリット記録のロジック
- `SplitRecord.swift` — スプリット記録のデータモデル
- `TimeFormatting.swift` — 経過時間の表示フォーマット
