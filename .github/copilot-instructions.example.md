# AIコーディングエージェントへの指示

## 重要

ユーザーはAIエージェントよりプログラミングが得意ですが、時短のためにAIエージェントにコーディングを依頼しています。

2回以上連続でテストを失敗した時は、現在の状況を整理して、一緒に解決方法を考えます。

私は GitHub
から学習した広範な知識を持っており、個別のアルゴリズムやライブラリの使い方は私が実装するよりも速いでしょう。テストコードを書いて動作確認しながら、ユーザーに説明しながらコードを書きます。

反面、現在のコンテキストに応じた処理は苦手です。コンテキストが不明瞭な時は、ユーザーに確認します。

## 作業開始準備

`git status` で現在の git のコンテキストを確認します。
もし指示された内容と無関係な変更が多い場合、現在の変更からユーザーに別のタスクとして開始するように提案してください。

無視するように言われた場合は、そのまま続行します。

## Gitワークフロー

このドキュメントでは、コミットとプルリクエストの作成に関するベストプラクティスを説明します。

### コミットの作成

コミットを作成する際は、以下の手順に従います：

1. 変更の確認
   ```bash
   # 未追跡ファイルと変更の確認
   git status

   # 変更内容の詳細確認
   git diff

   # コミットメッセージのスタイル確認
   git log
   ```

2. 変更の分析
   - 変更または追加されたファイルの特定
   - 変更の性質（新機能、バグ修正、リファクタリングなど）の把握
   - プロジェクトへの影響評価
   - 機密情報の有無確認

3. コミットメッセージの作成
   - 「なぜ」に焦点を当てる
   - 明確で簡潔な言葉を使用
   - 変更の目的を正確に反映
   - 一般的な表現を避ける
   - 英文で完結に、1文で示す

4. コミットの実行
   ```bash
   # 関連ファイルのみをステージング
   git add <files>

   # コミットメッセージの作成
   git commit -m "Add sign in feature and tests."
   ```

### プルリクエストの作成

プルリクエストを作成する際は、以下の手順に従います：

1. ブランチの状態確認
   ```bash
   # 未コミットの変更確認
   git status

   # 変更内容の確認
   git diff

   # mainからの差分確認
   git diff main...HEAD

   # コミット履歴の確認
   git log
   ```

2. 変更の分析
   - mainから分岐後のすべてのコミットの確認
   - 変更の性質と目的の把握
   - プロジェクトへの影響評価
   - 機密情報の有無確認

3. プルリクエストの作成
   ```bash
   # プルリクエストの作成（HEREDOCを使用）
   gh pr create --title "ログイン処理の追加" --body "$(cat <<'EOF'
   ## 概要

   ログイン処理のためのAPIコールとロジックを追加しました。

   ## 変更内容

   - Firebase authentication を用いたログイン処理の追加
     - Google Sign-in のサポート
   - テストケースの追加

   EOF
   )"
   ```

### 重要な注意事項

1. コミット関連
   - 可能な場合は `git commit -am` を使用
   - 関係ないファイルは含めない
   - 空のコミットは作成しない
   - git設定は変更しない

2. プルリクエスト関連
   - 必要に応じて新しいブランチを作成
   - 変更を適切にコミット
   - プルリクエストはレビューをしやすい単位で作成する
     - 変更の総数が500行以内を目安とする
   - 一つのタスクに対してプルリクエストが複数必要な場合は、必要に応じてブランチを新たに作ってから作業をする
   - リモートへのプッシュは `-u` フラグを使用
   - すべての変更を分析

3. 避けるべき操作
   - 対話的なgitコマンド（-iフラグ）の使用
   - リモートリポジトリへの直接プッシュ
   - git設定の変更

# コーディングプラクティス

## 原則（バックエンド）

### ドメイン駆動設計 (DDD)

- 値オブジェクトとエンティティを区別
- 集約で整合性を保証
- リポジトリでデータアクセスを抽象化
- 境界付けられたコンテキストを意識
- レイヤードアーキテクチャで関心事の細分化を意識

## 原則（フロントエンド）

### クリーンアーキテクチャ

- レイヤー分離の徹底
  - プレゼンテーション層：UI コンポーネントとイベントハンドラ
  - アプリケーション層：ユースケースとビジネスロジック
  - ドメイン層：ビジネスモデルと中核ロジック
  - データ層：APIクライアントやストレージアクセス
  - 各レイヤーがディレクトリ構造と一致するとは限らない
    - 採用されているフレームワークやライブラリのベストプラクティスを優先する

- 依存関係の方向性
  - 外側のレイヤーは内側のレイヤーに依存する
  - 内側のレイヤーは外側のレイヤーを知らない
  - 依存性逆転の原則により適切な抽象化を行う

- 責務の分離
  - UI コンポーネントはデータの表示と入力のみを担当
  - ビジネスロジックはプレゼンテーション層から分離
  - データ取得ロジックはリポジトリに集約

- ユースケース中心の設計
  - 機能ごとにユースケースを定義
  - 入力、処理、出力を明確に定義
  - ユースケース間の依存関係を最小化

- 依存性注入
  - 外部依存はインターフェースを通じて注入
  - テスト時にはモックに置き換え可能に
  - DIコンテナやプロバイダーを活用

### テスト駆動開発 (TDD)

- Red-Green-Refactorサイクル
- テストを仕様として扱う
- 小さな単位で反復
- 継続的なリファクタリング

## 実装手順

1. **型設計**
   - まず型を定義
   - ドメインの言語を型で表現

2. **純粋関数から実装**
   - 外部依存のない関数を先に
   - テストを先に書く

3. **副作用を分離**
   - IO操作は関数の境界に押し出す
   - 副作用を持つ処理をPromiseでラップ

4. **アダプター実装**
   - 外部サービスやDBへのアクセスを抽象化
   - テスト用モックを用意

## プラクティス

- 小さく始めて段階的に拡張
- 過度な抽象化を避ける
- コードよりも型を重視
- 複雑さに応じてアプローチを調整

## コードスタイル

- 関数優先（クラスは必要な場合のみ）
- 不変更新パターンの活用
- 早期リターンで条件分岐をフラット化
- エラーとユースケースの列挙型定義

## テスト戦略

- 純粋関数の単体テストを優先
- インメモリ実装によるリポジトリテスト
- テスト可能性を設計に組み込む
- アサートファースト：期待結果から逆算

## Dart

Dartでのコーディングにおける一般的なベストプラクティスをまとめます。

## 方針

- 設計の最初に型や関数・クラスのインターフェースを明確に設計する
  - 仕様や利用方法をファイルコメントで可能な限り記述する
- シンプルな実装
  - 内部状態を持たない処理は、クラスよりも関数ベースの実装を優先する
- イミュータブルオブジェクトの優先
  - 状態を管理する必要がある場合、イミュータブルオブジェクトを用いた状態管理を優先する
- 依存性の抽象化
  - 外部依存を明示的に注入し、Adapterパターンなどで隠蔽
  - テスト時はモックに差し替え可能な設計を心がける

## 型の使用方針

### 具体的な型を使用する

- `dynamic` の使用はできるだけ避け、明示的な型（あるいは型推論）を活用する
- 必要に応じてジェネリクスやユーティリティ型を利用し、型安全性を向上させる

### 型エイリアスの命名

意味のある名前をつけ、型の意図が分かるようにする。

例：

```dart
// Good
typedef UserId = String;
class UserData {
  final UserId id;
  final DateTime createdAt;
  UserData({required this.id, required this.createdAt});
}

// Bad
typedef Data = dynamic;
```

## エラー処理

### 例外処理と関数型の結果返却

Dartでは例外処理が一般的だが、パッケージ dartz などを活用して、Either や Result 型でエラーを扱う方法もある。

```dart
import 'package:dartz/dartz.dart';

class ApiError {
  final String message;
  ApiError(this.message);
}

Future<Either<ApiError, UserData>> fetchUser(String id) async {
  try {
    final response = await httpClient.get(Uri.parse('https://api.example.com/users/$id'));
    if (response.statusCode != 200) {
      return left(ApiError('HTTP error: ${response.statusCode}'));
    }
    final data = parseUserData(response.body);
    return right(data);
  } catch (e) {
    return left(ApiError(e is Exception ? e.toString() : 'Unknown error'));
  }
}
```

### エラー型の定義

発生しうるエラーの具体的ケースを列挙し、適切なメッセージとともに定義することで、呼び出し元でのエラー処理を明確にする。

## 実装パターン

### 関数ベースの実装（状態を持たない場合）

シンプルな処理やユーティリティ関数は関数として実装する

```dart
// インターフェース（typedef）としてログ出力の型を定義
typedef Logger = void Function(String message);

// 実装例
Logger createLogger() {
  return (String message) {
    final now = DateTime.now().toIso8601String();
    print('[$now] $message');
  };
}
```

### 状態管理が必要な実装

- 不変性の活用
  - 状態オブジェクトをイミュータブルに扱うことで、状態変更時は新しいインスタンスを生成する
- package:signalsの利用
- 一方向データフローの実現

```dart
import 'package:signals/signals.dart';

/// アプリケーションの状態を表す不変オブジェクト
class AppState {
  final int counter;
  const AppState({this.counter = 0});

  // 新しい状態を生成するためのヘルパー
  AppState copyWith({int? counter}) {
    return AppState(counter: counter ?? this.counter);
  }
}

/// Signalsパッケージを用いた状態管理クラス
class StateManager {
  // Signalは購読可能な状態コンテナ。初期状態はAppStateの定数インスタンスを利用。
  final Signal<AppState> stateSignal = Signal<AppState>(const AppState());

  // 状態を更新し、変更を通知する
  void increment() {
    final currentState = stateSignal.value;
    final newState = currentState.copyWith(counter: currentState.counter + 1);
    stateSignal.value = newState;
  }
}
```

### 一般的なルール

1. 依存性の注入
   - 外部依存はコンストラクタで注入
   - テスト時にモックに置き換え可能に
   - グローバルな状態を避ける

2. インターフェースの設計
   - 必要最小限のメソッドを定義
   - 実装の詳細を含めない
   - プラットフォーム固有の型を避ける

3. テスト容易性
   - モックの実装を簡潔に
   - エッジケースのテストを含める
   - テストヘルパーを適切に分離

4. コードの分割
   - 単一責任の原則に従う
   - 適切な粒度でモジュール化
   - 循環参照を避ける

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

# テスト駆動開発 (TDD) の基本

## 基本概念

テスト駆動開発（TDD）は以下のサイクルで進める開発手法です：

1. **Red**: まず失敗するテストを書く
2. **Green**: テストが通るように最小限の実装をする
3. **Refactor**: コードをリファクタリングして改善する

## 重要な考え方

- **テストは仕様である**: テストコードは実装の仕様を表現したもの
- **Assert-Act-Arrange の順序で考える**:
  1. まず期待する結果（アサーション）を定義
  2. 次に操作（テスト対象の処理）を定義
  3. 最後に準備（テスト環境のセットアップ）を定義
- **テスト名は「状況→操作→結果」の形式で記述**: 例:
  「有効なトークンの場合にユーザー情報を取得すると成功すること」

## リファクタリングフェーズの重要ツール

テストが通った後のリファクタリングフェーズでは、以下のツールを活用する。
例としてDartでのプロジェクトを想定している。

1. **静的解析・型チェック**:
   - `dart analyze`

2. **コードフォーマット**:
   - `dart fix --apply`

3. **コードカバレッジ測定**:
   - （package:coverageをインストールしていなければ `dart pub add dev:coverage` コマンドを実行する）
   - `dart run coverage:test_with_coverage`

4. **Gitによるバージョン管理**:
   - 各フェーズ（テスト作成→実装→リファクタリング）の完了時にコミット
   - タスク完了時にはユーザーに確認
