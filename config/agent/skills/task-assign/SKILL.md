---
name: task-assign
description: GitHub Issue を起点に、調査、実装、テスト、コミット、Pull Request 作成までを一貫して進めるスキル。ユーザーが「Issue を対応して」「Issue #123 を見て修正して」「issue を見て PR まで進めて」と依頼したときに使う。issue 番号の取得、issue 内容の理解、ブランチ作成、関連箇所の特定、実装、テスト、コミット、PR 作成、`Closes #<issue-number>` の付与までを扱う。
---

# Task Assign

GitHub Issue を実装タスクへ落とし込み、修正から PR 作成まで一貫して進める。

## ワークフロー

### Step 1: 対象 issue を特定する

- ユーザー依頼から issue 番号を抽出する。
- issue 番号がない場合は、実装作業に入る前に番号の提示を求める。

### Step 2: issue を読んで理解する

- `gh issue view` を使って issue を読む。
- 実際の問題、期待される挙動、想定スコープを具体的な言葉で言い直す。
- テスト可能な粒度で意図が明確になるまで、実装を始めない。

### Step 3: 作業ブランチを作成する

- `gwq add -b <branch-name>` で新しいブランチを作成する。
- ブランチ名には issue 番号を含める。
- たとえば `fix-issue-123-timeout` のように、修正内容や機能内容が分かる名前を付ける。

### Step 4: 調査して実装する

- コードベースを検索し、関連するファイルと挙動を特定する。
- issue を正しく解決するための最小変更を行う。
- `config/claude_code/CLAUDE.md` のリポジトリ規約に従う。

### Step 5: テストを追加して実行する

- 修正前は失敗し、修正後は通るテストを追加または更新する。
- 変更を検証するために relevant tests と必要な高信号のローカルチェックを実行する。
- 具体的な理由がない限りテストを省略しない。省略する場合は理由を明示する。

### Step 6: 変更をコミットする

- `../commit/SKILL.md` に記載された commit workflow に従う。
- commit message を確定する前に `../commit/references/conventional-commits.md` を読む。

### Step 7: Pull Request を作成する

- `../pr/SKILL.md` に記載された PR workflow に従う。
- PR 本文を作る前に `../pr/references/pr-format.md` を読む。
- PR 本文には次のセクションを含める:

```markdown
## Related issue
Closes #<issue-number>
```

## 運用ルール

- issue 理解を儀式扱いせず、必須の作業として扱う。
- ユーザーが明示的にスコープを広げない限り、ブランチはその issue に閉じる。
- 実用的であれば、test-first または test-driven な検証を優先する。
- 最終 PR から issue 連携を漏らさない。
