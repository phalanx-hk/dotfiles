# uv のまとめ

## 概要

uv は以下のような特徴を持つ python パッケージおよびプロジェクト管理ツールです

- pip、pip-tools、pipx、poetry、pyenv、twine、virtualenv などを置き換える単一のツール
- pip よりも 10〜100 倍高速
- ユニバーサルロックファイルを含む包括的なプロジェクト管理機能
- インライン依存関係メタデータをサポートしたスクリプト実行機能
- 依存関係の重複排除のためのグローバルキャッシュによる効率的なディスク使用

## インストール

### （推奨）mise からインストールする方法

```bash
mise install uv
```

### スタンドアローンインストーラーを使用する方法

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## 使い方

### プロジェクト管理

#### プロジェクト初期化

新しいプロジェクトを作成します。`pyproject.toml`ファイルが生成され、プロジェクトのメタデータや依存関係が含まれます。

```bash
# 現在のディレクトリにプロジェクトを初期化
uv init

# 指定したディレクトリにプロジェクトを作成
uv init my_project

# ライブラリプロジェクトとして初期化（配布用パッケージ）
uv init --lib my_library

# アプリケーションプロジェクトとして初期化（CLI/Webアプリなど）
uv init --app my_app

# スクリプトファイルを作成（PEP 723対応）
uv init --script script.py
```

#### 依存関係の追加・削除

プロジェクトに依存関係を追加または削除します。

```bash
# パッケージを追加
uv add requests

# 特定のバージョンを指定して追加
uv add "django>=4.0,<5.0"

# 開発依存関係として追加
uv add --dev pytest

# オプショナル依存関係として追加
uv add --optional test pytest coverage

# 依存関係グループに追加
uv add --group lint ruff mypy

# パッケージを削除
uv remove requests

# 開発依存関係を削除
uv remove --dev pytest
```

#### 仮想環境の管理

プロジェクトの仮想環境を作成・管理します。

```bash
# 仮想環境を作成（.venvディレクトリに作成される）
uv venv

# 特定のPythonバージョンで仮想環境を作成
uv venv --python 3.11

# 指定したパスに仮想環境を作成
uv venv /path/to/venv

# システムサイトパッケージにアクセス可能な仮想環境を作成
uv venv --system-site-packages

# seed パッケージ（pip、setuptools、wheel）をインストール
uv venv --seed
```

#### プロジェクト環境の同期

プロジェクトの依存関係をインストールし、環境を最新状態にします。

```bash
# プロジェクト環境を同期（依存関係をインストール）
uv sync

# 開発依存関係も含めて同期
uv sync --dev

# 特定のオプショナル依存関係を含めて同期
uv sync --extra test

# すべてのオプショナル依存関係を含めて同期
uv sync --all-extras

# 特定の依存関係グループを含めて同期
uv sync --group lint

# 厳密でない同期（余分なパッケージを削除しない）
uv sync --inexact

# プロジェクト自体をインストールしない
uv sync --no-install-project
```

#### ロックファイルの管理

プロジェクトの依存関係を解決し、ロックファイルを生成・更新します。

```bash
# ロックファイル（uv.lock）を生成・更新
uv lock

# ロックファイルが最新かチェック
uv lock --check

# ドライランモード（実際に書き込まない）
uv lock --dry-run

# パッケージをアップグレードしてロック
uv lock --upgrade

# 特定のパッケージのみアップグレード
uv lock --upgrade-package requests
```

### スクリプト実行とコマンド実行

#### プロジェクト内でのコマンド実行

プロジェクト環境でコマンドやスクリプトを実行します。

```bash
# Pythonスクリプトを実行
uv run python script.py

# モジュールを実行
uv run -m pytest

# 一時的に依存関係を追加して実行
uv run --with requests python script.py

# requirements.txtの依存関係を追加して実行
uv run --with-requirements requirements.txt python script.py

# 分離された環境で実行
uv run --isolated python script.py

# PEP 723スクリプトを実行
uv run script.py

# 環境変数ファイルを読み込んで実行
uv run --env-file .env python script.py
```

### パッケージ管理（pip 互換インターフェース）

> **⚠️ 重要な注意事項**
>
> `uv pip` コマンドは既存の pip と互換性のためのインターフェースです。**通常のプロジェクト開発では `uv add`、`uv remove`、`uv sync` を使用することを強く推奨します。**
>
> `uv pip` を使用するのは以下の場合のみにしてください：
>
> - ライブラリのドキュメントで明示的に `pip install` が推奨されている場合
> - レガシーシステムとの互換性が必要な場合
> - プロジェクト管理外で一時的にパッケージをテストする場合

#### パッケージのインストール・アンインストール

```bash
# パッケージをインストール（非推奨 - 代わりに uv add を使用）
uv pip install requests

# requirements.txtからインストール（非推奨 - 代わりに uv sync を使用）
uv pip install -r requirements.txt

# パッケージをアンインストール（非推奨 - 代わりに uv remove を使用）
uv pip uninstall requests

# インストール済みパッケージの一覧表示
uv pip list

# パッケージの詳細情報表示
uv pip show requests

# 依存関係ツリーの表示
uv tree
```

### Python バージョン管理

#### Python インタープリターの管理

```bash
# 利用可能なPythonバージョンを表示
uv python list

# 特定のPythonバージョンをインストール
uv python install 3.11

# インストール済みのPythonバージョンを表示
uv python list --only-installed

# Pythonインタープリターの場所を表示
uv python find

# 特定のバージョンのPythonインタープリターを検索
uv python find 3.11
```

### ワークスペース管理

#### マルチパッケージプロジェクト

```bash
# ワークスペース全体を同期
uv sync --all-packages

# 特定のワークスペースメンバーのみ同期
uv sync --package my-package

# ワークスペース全体で依存関係を追加
uv add --package my-package requests
```

### キャッシュ管理

#### キャッシュの表示・削除

```bash
# キャッシュディレクトリの場所を表示
uv cache dir

# キャッシュサイズを表示
uv cache size

# キャッシュをクリア
uv cache clean

# 特定のパッケージのキャッシュをクリア
uv cache clean requests
```

### 設定とオプション

#### グローバルオプション

```bash
# 詳細出力でコマンドを実行
uv --verbose sync

# 静寂モードでコマンドを実行
uv --quiet sync

# オフラインモードで実行（ネットワークアクセスなし）
uv --offline sync

# キャッシュを使用しない
uv --no-cache sync

# 特定のディレクトリで実行
uv --directory /path/to/project sync

# 設定ファイルを指定
uv --config-file uv.toml sync
```

#### 環境変数での設定

主要な環境変数：

```bash
# デフォルトのPythonインタープリター
export UV_PYTHON=3.11

# キャッシュディレクトリ
export UV_CACHE_DIR=/path/to/cache

# プロジェクトディレクトリ
export UV_PROJECT=/path/to/project

# インデックスURL
export UV_INDEX_URL=https://pypi.org/simple

# ネットワークアクセス無効化
export UV_OFFLINE=1

# キャッシュ無効化
export UV_NO_CACHE=1
```

### よく使用されるワークフロー

#### 新しいプロジェクトの開始

```bash
# プロジェクトを作成
uv init my-project
cd my-project

# 依存関係を追加
uv add requests pytest

# 環境を同期
uv sync

# テストを実行
uv run pytest
```

#### 既存プロジェクトのセットアップ

```bash
# プロジェクトディレクトリに移動
cd existing-project

# 環境を同期（依存関係をインストール）
uv sync

# アプリケーションを実行
uv run python main.py
```

#### 依存関係の更新

```bash
# 全ての依存関係を最新バージョンに更新
uv lock --upgrade
uv sync

# 特定のパッケージのみ更新
uv lock --upgrade-package requests
uv sync
```

#### 開発環境での作業

```bash
# 開発依存関係を含めて環境をセットアップ
uv sync --dev

# リンターを実行
uv run ruff check

# フォーマッターを実行
uv run ruff format

# テストを実行
uv run pytest

# 型チェックを実行
uv run mypy src/
```
