# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## コマンド (Commands)

### セットアップコマンド (Setup Commands)

```bash
# macOS環境のセットアップ
make mac

# Ubuntu環境のセットアップ
make ubuntu
```

### リンティングコマンド (Linting Commands)

```bash
# シェルスクリプトのリンティング
shellcheck **/*.sh

# GitHub Actionsのリンティング
actionlint
```

## リポジトリ構造 (Repository Structure)

このリポジトリはdotfilesを管理するためのものです。主な構造は以下の通りです：

- `config/`: 各種設定ファイル
  - 各ツールのディレクトリ（bat, fd, gh, git, mise, zshなど）
  - 各ディレクトリには、そのツールの設定ファイルが格納
  
- `install/`: インストールスクリプト
  - `common/`: 共通のインストールスクリプト
  - `mac/`: macOS特有のインストールスクリプト
  - `ubuntu/`: Ubuntu特有のインストールスクリプト
  - `link.sh`: 設定ファイルのシンボリックリンクを作成するスクリプト

## アーキテクチャ概要 (Architecture Overview)

このdotfilesリポジトリは以下の主要コンポーネントで構成されています：

1. **設定ファイル管理**: `config/`ディレクトリにある各種ツールの設定ファイル

2. **環境セットアップ**:
   - 必要なパッケージのインストール（macOSではHomebrewを使用、Ubuntuではaptを使用）
   - 共通ツール（mise, GitHub CLI, VSCodeなど）のインストール
   - 設定ファイルへのシンボリックリンク作成

3. **開発ツール管理**:
   - miseを使用して言語や開発ツールのバージョンを管理（rust, node, go, terraformなど）
   - CLIツールの管理（trivy, bat, eza, ripgrep, starshipなど）

## 開発の慣例 (Development Conventions)

1. **シェルスクリプト**: 
   - `set -Eeuxo pipefail`などの安全なシェルスクリプトの慣例を使用
   - shellcheckに対応したコードを記述

2. **GitHub Actions**:
   - `lint.yml`でコード品質チェック
   - `mac.yml`と`ubuntu.yml`でセットアップスクリプトのテスト

## 注意事項

1. 設定ファイルを修正する際は、元の設定スタイルに合わせること
2. シェルスクリプトにはエラーハンドリングを含めること
3. 異なるOSで共通の機能は`common/`ディレクトリに配置すること
4. OS固有の機能はそれぞれのディレクトリ（`mac/`または`ubuntu/`）に配置すること