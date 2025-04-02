## Flutter

Flutterでの開発における一般的なベストプラクティスをまとめます。

## 方針

- 宣言的UIの徹底
- 不変性と再利用性の向上
  - 状態やウィジェットは可能な限りイミュータブルにする
  - const コンストラクタや不変オブジェクトを活用することでパフォーマンス向上を図る
- UIとビジネスロジックの分離
  - プレゼンテーション層（UI）とロジック層を明確に分け、テスト容易性・保守性を高める
- 依存性の注入と一方向データフロー
  - 状態管理や外部依存はDIフレームワーク（Provider, Riverpod, GetItなど）を活用し、データの流れを一方向に保つ
- リンター・フォーマッターの活用
  - `flutter analyze` や `dart format` を利用して、コード品質と一貫性を維持する
  - Flutter向けのlintルール（flutter_lintsなど）をプロジェクトに導入する
- テストの充実
  - 単体テスト、ウィジェットテストを適切に組み合わせ、早期にバグを検出する体制を構築する

## ウィジェット設計の基本

### constコンストラクタの活用

可能な限りconstコンストラクタを利用し、ウィジェットの再構築コストを削減する。

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const Text('Hello, Flutter!');
  }
}
```

### 再利用可能なウィジェットの抽出

共通パターンや複雑なUI部分はCustom Widgetに切り出し、コードの重複を避ける。

### Compositionを優先する

継承ではなく、複数のウィジェットを組み合わせてUIを構築する。これにより、柔軟性と再利用性が向上する。

### 適切なWidgetの切り出し

特定のファイル内でのみ使うUIコンポーネントは、関数ではなくCustom Widget（StatelessWidget, StatefulWidget）として適切な単位で切り出す。
基本的には変化する状態を考慮したうえで、状態が変更される範囲、それ以外の範囲をそれぞれWidgetとして定義する。
こうすることでWidgetの責任範囲が明確になるほか、constコンストラクターを扱いやすくなりパフォーマンス向上にも繋がる。

例：

```dart
final count = signal(0);

class SomeParent extends StatelessWidget {
  const SomeParent({super.key});

  @override
  Widget build(BuildContext context) {
    return const FractionallySizedBox(
      widthFactor: 0.8,
      child: SomeChild(),
    );
  }
}

class SomeChild extends StatelessWidget {
  const SomeChild({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) => Text(count.value.toString()));
  }
}
```

## 状態管理

### イミュータブルな状態管理

- 状態はイミュータブルオブジェクトとして管理し、変更時は新しい状態オブジェクトを生成する
- Riverpod、Bloc、Providerなどのパッケージを活用し、一方向データフローを実現する
- Signalsパッケージなど、リアクティブな手法を用いると、状態更新時の通知が自動化され、UI側は最新状態に基づいて再描画される

```dart
// Riverpodを利用した例
class CounterState {
  final int count;
  const CounterState(this.count);
}

class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier() : super(const CounterState(0));

  void increment() => state = CounterState(state.count + 1);
}
```

### ライフサイクルに応じた状態管理の粒度

グローバルな状態から、画面単位、ウィジェット単位まで、適切なスコープで状態管理を行うことで、不要な再ビルドや副作用を防止する。

## エラー処理とロギング

- エラーハンドリングの一元管理
  - 非同期処理やAPI呼び出しでは、try-catchを利用して例外を捕捉し、ユーザーに適切なフィードバックを提供する
- ロギングツールの活用
  - LoggerパッケージやFlutter DevToolsを利用し、デバッグ時の情報収集と問題解決を支援する

## 自動テスト

- ビジネスロジックを記述する層では必ず単体テストをセットで書く
- カスタムWidgetにおいても、基礎的なWidgetはWidget testを書く
