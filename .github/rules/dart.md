## Dart

Dartでのコーディングにおける一般的なベストプラクティスをまとめます。

## 方針

- 設計の最初に
  - 型や関数・クラスのインターフェースを明確に設計する。仕様や利用方法をファイルコメントで可能な限り記述する。
- シンプルな実装
  - 内部状態を持たない処理は、クラスよりも関数ベースの実装を優先する。
- イミュータブルオブジェクトの優先
  - 状態を管理する必要がある場合、イミュータブルオブジェクトを用いた状態管理を優先する。
- 依存性の抽象化
  - 外部依存を明示的に注入し、Adapterパターンなどで隠蔽。テスト時はモックに差し替え可能な設計を心がける。

## 型の使用方針

### 具体的な型を使用する

- `dynamic` の使用はできるだけ避け、明示的な型（あるいは型推論）を活用する。
- 必要に応じてジェネリクスやユーティリティ型を利用し、型安全性を向上させる。

### 型エイリアスの命名

- 意味のある名前をつけ、型の意図が分かるようにする。

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

- Dartでは例外処理が一般的ですが、パッケージ dartz などを活用して、Either や Result 型でエラーを扱う方法もあります。

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

- 発生しうるエラーの具体的ケースを列挙し、適切なメッセージとともに定義することで、呼び出し元でのエラー処理を明確にする。

## 実装パターン

### 関数ベースの実装（状態を持たない場合）

- シンプルな処理やユーティリティ関数は関数として実装する

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
