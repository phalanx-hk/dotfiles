---
name: Gemini Search Skill
description: 最新情報の確認・要出典の事実確認・比較検討など「Web検索」が必要なときに使用するスキル。Web検索は必ず Gemini CLI で実行する: gemini --prompt "WebSearch: <query>"。結果URLの本文確認が必要な場合のみ WebFetch を使う。
---

# Gemini Search Skill

## いつ使うか

- 「最新」「リリース」「価格」「仕様」「規約」など、知識が陳腐化しやすい質問
- 根拠（出典URL）が必要な事実確認
- 複数候補の比較（製品・ツール・サービスなど）

## 使い方

Web検索は必ず `gemini` CLIで実行する

```bash
gemini --prompt "WebSearch: <検索クエリ>"
```

## 重要な注意事項

- Web検索を行う際には、常に `gemini` CLIを使用します
- 組み込みの`WebSearch`ツールは絶対に使用しないでください
- 結果URLの本文確認が必要な場合のみ WebFetch を使ってください

## 使用例

ユーザーが「最新のPython 3.12の新機能について教えて」と質問した場合

```bash
gemini --prompt "WebSearch: Python 3.12 新機能"
```

ユーザーが「Reactの最新バージョンは？」と質問した場合

```bash
gemini --prompt "WebSearch: React 最新バージョン"
```
