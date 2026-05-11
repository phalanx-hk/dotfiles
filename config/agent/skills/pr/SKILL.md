---
name: pr
description: 現在のブランチの変更から GitHub Pull Request を作成するためのスキル。ユーザーが「PR を作って」「プルリクを作成して」「現在の差分から PR 文面を書いて」「PR タイトルと説明を作って」と依頼したときに使う。ブランチ確認、変更分析、push 判定、PR title と body の生成、`claude` ラベル確認、`gh pr create` 実行までを扱う。
---

# PR

現在のブランチの差分とコミット履歴をもとに、レビューしやすい Pull Request を作成する。

## ワークフロー

### Step 1: ブランチ状態を確認する

- 現在のブランチ名を確認する。
- ブランチが `main` または `master` の場合は処理を止め、feature branch を作成または切り替えるよう伝える。
- `git status` を実行し、未コミット変更が残っているか確認する。
- 未コミット変更がある場合は、ユーザーが明示的に draft 運用を望んでいない限り、コミット後に PR を作るべきことを説明する。

### Step 2: ブランチ履歴と diff を分析する

- デフォルトブランチとの差分コミット範囲を確認する。
- デフォルトブランチとの差分 diff を確認する。
- commit message だけに頼らず、実際の変更内容から PR の type と中心的な変更点を推定する。

タイトルと本文を作る前に `references/pr-format.md` を読む。

### Step 3: リモートブランチの有無を確認する

- 現在のブランチに upstream branch があるか確認する。
- ない場合は、upstream tracking 付きで push してから PR を作成する。

### Step 4: PR メタデータを準備する

- Conventional Commits 形式の title を作成する。
- `Summary`、`Changes`、`Test plan`、`Additional notes` を含む本文を作成する。
- `Summary` は短く保ち、最も重要な変更に絞る。
- 実装が未完了、ブロック中、または検証待ちの場合にだけ Draft PR を使う。

### Step 5: `claude` ラベルの存在を確認する

- `gh label list` で既存ラベルを確認する。
- `claude` が存在しない場合は、設定された色と説明で作成する。

### Step 6: PR を作成する

- 準備した title と body を使って `gh pr create` を実行する。
- `claude` ラベルを付与する。
- タスク文脈上必要であれば issue 連携を含める。

## 運用ルール

- `main` または `master` から PR を作成しない。
- 実際に走らせていないテストを書かない。検証状況は事実に合わせて記述する。
- commit message が荒れていても、タイトルは branch diff に一致させる。
- 本文は、レビュー担当者が意図、変更範囲、検証内容を素早く理解できる簡潔さを優先する。

