# python スタイルガイド

## 前提

- python のバージョンは **3.12** 以上を前提としています。
- コードの可読性と保守性を重視し、PEP8 に準拠したスタイルを採用します。

## 依存関係管理

依存関係の管理には`uv`を使用しています。`pip`は禁止としているため、`uv`を使用してパッケージのインストールや仮想環境の管理を行ってください。
`uv`の使い方は @uv.md を参照してください。

## format/lint

### ライブラリ

コードのフォーマットには`ruff`を使用しています。

### 規則

- フォーマットとリンティングのルールは、`ruff.toml`に記載されています。
- `pyproject.toml`にルールを記載することもできますが、原則として`ruff.toml`に記載してください。
- `ruff.toml`の ignore ルールは変更しないでください。実装時にエラーが発生することがありますが、エラーログに従ってコードを修正してください。
- コード単位で format/lint を無視することも禁止です。コードの末尾に`# noqa: <rule>`を追加することは許可されていません。

### 使い方

ワークスペース全体に適用する場合は、以下の実行をしてください

```bash
# format
uv run format

# lint
uv run check --fix
```

特定のファイルやディレクトリに対して実行する場合は、以下のように指定してください。

```bash
# format
uv run format <file_or_directory>

# lint
uv run check --fix <file_or_directory>
```

## 型チェック

### ライブラリ

型チェックには`mypy`を使用しています。

### 規則

- 型チェックのルールは、`mypy.ini`に記載されています。
- `pyproject.toml`にルールを記載することもできますが、原則として`mypy.ini`に記載してください。
- `mypy.ini`の ignore ルールは変更しないでください。実装時にエラーが発生することがありますが、エラーログに従ってコードを修正してください。
- コード単位で型チェックを無視することも禁止です。型チェックを無視するためのコメント（例：`# type: ignore`）を追加することは許可されていません。

### 使い方

ワークスペース全体に適用する場合は、以下の実行をしてください

```bash
uv run mypy ./
```

特定のファイルやディレクトリに対して実行する場合は、以下のように指定してください。

```bash
uv run mypy <file_or_directory>
```

## テスト

### ライブラリ

テストには`pytest`を使用しています。

### 規則

- テストのルールは、`pytest.ini`に記載されています。
- `pyproject.toml`にルールを記載することもできますが、原則として`pytest.ini`に記載してください。

## 型安全性とエラーハンドリング

### 型アノテーション

#### 基本方針

- 全ての関数とメソッドに型アノテーションを記載する
- 型アノテーションは PEP585 に従い、`typing.List` や `typing.Dict` ではなく、組み込みの `list` や `dict` を使用する
- mypy の型チェックを必ず通すこと
- `typing.Any`は極力使用しない。ただし、外部ライブラリや動的なデータ構造を扱う場合は例外とする
- 型の複雑さよりも可読性を優先し、必要に応じて Type Alias や NewType を使用して可読性を向上させる、もしくは pydantic などのデータモデルを使用する

#### TypeAlias vs NewType vs Pydantic の使い分け

| 手法          | 用途           | 静的型チェック           | 実行時型チェック |
| ------------- | -------------- | ------------------------ | ---------------- |
| **TypeAlias** | 可読性向上     | ❌                       | ❌               |
| **NewType**   | 型安全性確保   | ✅ (mypy でチェック可能) | ❌ (実体は同じ)  |
| **Pydantic**  | バリデーション | ✅ (mypy でチェック可能) | ✅               |

##### TypeAlias

- 可読性を向上させるために使用しますが、型安全性は提供しません。
- ドメインコードをコードに明示的に示したいが、型安全性は必要ない場合に使用します。
- `typing.TypeAlias`は 3.12 から非推奨となり、`type`を使って型エイリアスであることを明示することが推奨されています。

```python
UserId: type = int
```

##### NewType

- 型安全性を確保するために使用します。
- ランタイムでは同じ型として扱われるため、型チェックツール（mypy など）でのみ効果があります。
- ID, 単位, 為替レートなど「値は同じ型でも混ぜたら危険」な場面、ランタイム性能を落とさずに静的解析で早期にバグを見つけるために使用します。

```python
from typing import NewType

UserId = NewType('UserId', int)

def get_user_name(user_id: UserId) -> str:
    ...

  get_user_name(UserId(123))  # 型安全性が確保される
  get_user_name(123)  # mypy エラー
```

##### Pydantic

- データのバリデーションとシリアライゼーションを行うために使用します。
- データモデルを定義し、実行時にデータの整合性
- API や外部ファイルなど、信頼できないデータソースからの入力を扱う場合に使用します。

```python
from pydantic import BaseModel, Field, EmailStr
class User(BaseModel):
    id: int
    name: str
    email: EmailStr = Field(..., description="ユーザーのメールアドレス")

User(id=1, name="John Doe", email="hoge@gmail.com")  # 正常
User(id=2, name="Jane Doe", email="invalid-email")  # ValidationError
```

#### Good/Bad の例

TODO: 長くなりすぎるとコンテキストを圧迫するため、必要な部分を考え中

### エラーハンドリング

#### 基本方針

- 具体的な例外タイプをキャッチし、`Exception` の汎用キャッチは避ける
- 例外の再発生時は context を保持する（`raise ... from e`）
- カスタム例外クラスでドメインエラーを表現する

#### 例外の適切なキャッチ

```python
# Good: 具体的な例外をキャッチ
def read_config_file(file_path: str) -> dict[str, Any]:
    """
    ...

    Raises:
        FileNotFoundError: ファイルが存在しない場合
        PermissionError: ファイルの読み取り権限がない場合
        ValueError: JSON形式が無効な場合
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        raise FileNotFoundError(f"設定ファイルが見つかりません: {file_path}")
    except PermissionError:
        raise PermissionError(f"設定ファイルの読み取り権限がありません: {file_path}")
    except json.JSONDecodeError as e:
        raise ValueError(f"無効なJSON形式: {file_path}") from e

# Bad: 汎用的な例外キャッチ
def read_config_file(file_path: str) -> dict[str, Any]:
    try:
        with open(file_path, 'r') as f:
            return json.load(f)
    except Exception as e:  # 何でもキャッチしてしまう
        print(f"Error: {e}")
        return {}
```

#### カスタム例外の定義と使用

```python
# ドメイン固有の例外クラスを定義
class UserNotFoundError(ValueError):
    """ユーザーが見つからない場合の例外。"""

    def __init__(self, user_id: int) -> None:
        super().__init__(f"ユーザーが見つかりません: {user_id}")
        self.user_id = user_id

class InvalidUserDataError(ValueError):
    """無効なユーザーデータの場合の例外。"""
    pass

# 使用例
def get_user(user_id: int) -> User:
    """
    ...

    Raises:
        UserNotFoundError: 指定されたユーザーが存在しない場合
    """
    user = repository.find_by_id(user_id)
    if user is None:
        raise UserNotFoundError(user_id)
    return user
```

## 命名規則

### 基本原則

- 関数名は、変数、モジュールは`snake_case`を使用
- クラス名、型、列挙型は`CamelCase`を使用
- 定数と静的変数には`SCREAMING_SNAKE_CASE`を使用
- 意味のある名前を使用し、短縮形や略語は避ける
  - 例: `uid` や `db_conn` ではなく、`user_id` や `database_connection` を使用

## コメントとドキュメント

### コメント

- WHY を説明し、WHAT は避けます。コードから明らかな内容ではなく、なぜその実装を選択したのか、どのような背景や制約があるのかを説明します。
- コメントはコードの意図を明確にするために使用し、冗長なコメントや明白な内容は避ける

### Docstring

- Google style のドキュメンテーション文字列（docstring）を使用
- 記載内容:
  - 関数/クラスの機能を簡潔に説明
  - Args: 引数の説明
  - Returns: 戻り値の説明
  - どのような例外が発生するかを記載

```python
def fetch_user_name(user_id: int) -> str:
    """
    ユーザーIDからユーザー名を取得する。

    Args:
        user_id (int): ユーザーのID

    Returns:
        str: ユーザー名

    Raises:
        UserNotFoundError: 指定されたユーザーが存在しない場合
    """
    ...
```

## 制御フロー

### ガード節

ガード節は、異常系や特別なケースを関数の冒頭で処理し、else 句を使わずに早期リターンする書き方です。

```python
# Bad: 深いネスト
def process_order(order):
    if order is not None:
        if order.is_valid():
            if order.has_items():
                return calculate_total(order)
            else:
                return 0
        else:
            raise InvalidOrderError()
    else:
        raise OrderNotFoundError()

# Good: ガード節で早期リターン
def process_order(order):
    if order is None:
        raise OrderNotFoundError()

    if not order.is_valid():
        raise InvalidOrderError()

    if not order.has_items():
        return 0

    return calculate_total(order)
```

## 関数設計

### 単一責任の原則

1 つの関数は 1 つのことだけを行うべきです。ユーザーデータ処理関数がバリデーション、データ変換、データベース保存、メール送信を全て行うのではなく、それぞれを独立した関数に分離します。これにより各機能のテストが容易になり、変更時の影響範囲が限定されます。

### 関数の長さ制限

1 関数は 20-30 行以内を目安とします。これを超える場合は、論理的なまとまりで複数の関数に分割します。長い関数は理解が困難で、テストやデバッグが困難になります。

### 引数の数制限

引数は 3-4 個以内を推奨します。多い場合は pydantic モデルや dataclass を活用して関連するパラメータをまとめることを検討します。

### 純粋関数の推奨

副作用のない関数を可能な限り作成します。同じ入力に対して常に同じ出力を返し、外部状態を変更しない関数は、テストが容易で予測可能な動作をします。

## クラス設計（Python）

### いつクラスを使うか

- 値オブジェクト: 同じ属性なら同一と見なせる（例: Point(x, y), RGB(r, g, b)）。入力バリデーションが不要なら `@dataclass(frozen=True)`、バリデーションが必要なら `pydantic.BaseModel (v2) + frozen=True` を推奨。

- エンティティ: 一意な ID とライフサイクルを持つ（例: `User(id, name, email)`）。
- サービスオブジェクト: 状態をほぼ持たず、振る舞いをまとめる。@staticmethod か関数で十分ならクラスを避ける。

### クラス構成の原則

| 観点                  | 推奨                                                                                     |
| --------------------- | ---------------------------------------------------------------------------------------- |
| **単一責任**          | 1 クラス = 1 概念。副作用のあるユーティリティ関数を混在させない。                        |
| **公開 API の最小化** | `__all__` または `_private` 命名で外部インターフェースを明示。                           |
| **継承より構成**      | まず委譲 (`has-a`) を検討し、どうしても共通ロジックを再利用したい場合のみ継承 (`is-a`)。 |
| **データ表現**        | 不変データは `@dataclass(frozen=True)`, `typing.NamedTuple`, `attrs` などで簡潔に。      |
| **リソース管理**      | 外部リソースを握る場合は `__enter__ / __exit__` を実装し `with` で使えるように。         |
| **型ヒント**          | すべての属性・引数・戻り値を `typing` で明示し、mypy を CI に統合。                      |
| **immutability**      | 意図しない再代入を防ぐため、可能なら `frozen=True` や `__slots__` を利用。               |
