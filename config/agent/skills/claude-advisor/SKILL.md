---
name: claude-advisor
description: "Codexの計画・実装内容・差分・検証結果をClaude Codeに渡して、読み取り中心のセカンドレビューを受けるスキル。トリガー: ユーザが「Claudeにレビューして」「Claude Codeに見てもらって」「セカンドオピニオンを得て」「計画や実装をレビューして」と依頼したとき、または大きめの変更前後に別モデルの観点で設計・バグ・テスト不足を確認したいとき。"
---

# Claude Advisor

Codexの作業計画や実装結果をClaude Codeに渡し、レビュー観点の抜け・設計リスク・バグ・テスト不足を確認するスキル。

## ワークフロー

### Step 1: レビュー材料を整理する

ユーザの依頼と現在の作業状況から、以下を集める:

- 目的と成功条件
- Codexが立てた計画または実装方針
- 実装済みの場合は変更概要と主要な変更ファイル
- `git status --short` と関連する `git diff`
- 実行したテスト・ビルド・静的解析とその結果
- Codex自身が気にしているリスク、迷っている点、未確認事項

レビュー材料が不足している場合は、まず読み取り専用のコマンドで観測する。Claudeに丸投げせず、Codex側でレビュー対象を明確にしてから渡す。

### Step 2: Claudeへのプロンプトを構築する

Claudeには、レビューに徹すること、ファイル編集・コミット・修正実行をしないことを明示する。

プロンプトの構成例:

```markdown
あなたはClaude Codeとして、Codexの計画と実行内容をレビューしてください。
この依頼ではレビューのみを行い、ファイル編集・コミット・修正実行はしないでください。

## 目的

[ユーザの目的と成功条件]

## Codexの計画 / 方針

[計画または実装方針]

## 実装内容

[変更概要、主要ファイル、判断理由]

## 差分

[git diffの要点または全文]

## 検証結果

[実行したコマンド、結果、未実行なら理由]

## 気になっている点

[Codexが懸念しているリスクや未確認事項]

## レビューしてほしい観点

- バグ、仕様漏れ、回帰リスク
- 設計や責務分離の問題
- セキュリティ、安全性、破壊的変更の懸念
- テスト不足、検証不足
- より小さく安全にするための具体的な修正案

出力は重要度順に、具体的な根拠と該当箇所を添えてください。
問題がない場合も、残るリスクと追加で確認すべき点を明示してください。
```

### Step 3: Claude Codeを読み取り中心で呼び出す

Bashツールで `claude -p` を実行し、出力を一時ファイルに書き出す。セッションや権限の影響を抑えるため、レビュー用途では `--no-session-persistence` と `--permission-mode plan` を使う。

```bash
OUTFILE=$(mktemp /tmp/claude-advisor-XXXXXX.md)
echo "output: $OUTFILE"
timeout 180 claude -p \
  --no-session-persistence \
  --permission-mode plan \
  --output-format text \
  --allowedTools "Read,Grep,Glob,Bash(git diff *),Bash(git status *),Bash(rg *),Bash(sed *),Bash(nl *),Bash(ls *)" \
  "プロンプト内容" > "$OUTFILE"
```

プロンプトにコードブロック（` ``` `）またはバッククォート（`` ` ``）が含まれる場合は、必ずヒアドキュメントを使う。

```bash
OUTFILE=$(mktemp /tmp/claude-advisor-XXXXXX.md)
echo "output: $OUTFILE"
timeout 180 claude -p \
  --no-session-persistence \
  --permission-mode plan \
  --output-format text \
  --allowedTools "Read,Grep,Glob,Bash(git diff *),Bash(git status *),Bash(rg *),Bash(sed *),Bash(nl *),Bash(ls *)" \
  "$(cat <<'EOF'
あなたはClaude Codeとして、Codexの計画と実行内容をレビューしてください。

## 差分
```diff
...
```
EOF
)" > "$OUTFILE"
```

`'EOF'` をシングルクォートで囲み、プロンプト内の `` ` `` や `$` がシェル展開されないようにする。

### Step 4: 出力を読み取り、一時ファイルを削除する

Step 3の出力に表示されたパス（例: `/tmp/claude-advisor-abc123.md`）を読み取る。`$OUTFILE` はシェル変数なので、ツール呼び出しをまたいで参照できない点に注意する。

読み取り後は一時ファイルを削除する。

```bash
rm -f "/tmp/claude-advisor-abc123.md"
```

### Step 5: Codexの判断としてユーザに返す

Claudeの回答をそのまま転記しない。Codexが内容を検証し、採用すべき指摘・保留すべき指摘・誤っている指摘を分けて説明する。

出力では以下を含める:

- Claudeの主要指摘とCodexの見解
- 実際に対応すべき修正案または確認作業
- 採用しない指摘がある場合はその理由
- 残るリスクと追加検証の有無

ユーザが実装まで求めている場合でも、Claude Advisorの呼び出し自体はレビュー取得までに留める。修正はCodexがレビュー内容を評価した後、通常の作業として行う。

## 注意事項

- `--dangerously-skip-permissions` や `--permission-mode bypassPermissions` はレビュー用途では使わない。
- Claudeに編集・コミット・push・外部送信を依頼しない。
- 機密情報、トークン、個人情報が差分やログに含まれる場合は、マスクしてから渡す。
- タイムアウトした場合は、差分やログを短くして再試行する。
- Claudeの指摘は助言として扱い、最終判断はCodexが観測事実とユーザ要件に基づいて行う。
