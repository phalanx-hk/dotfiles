---
name: obsidian-formatter
description: "Obsidian Vault 向けに Markdown を変換するスキル。article-summarizer の出力など、プレーン Markdown を Obsidian 独自記法（YAML プロパティ、wikilink、embed、ハッシュタグ、コールアウト、ブロック参照）に最適化する。ユーザーが既存 Markdown を Obsidian 向けに整形・最適化したいとき、または article-summarizer 出力を Vault に取り込むときに使用する。"
---

# Obsidian Formatter

プレーン Markdown を Obsidian Vault 向けの独自記法に変換する。`article-summarizer` の生成物のような構造化された記事 Markdown を、Properties / Wikilink / Embed / Callout / Tag に最適化された Obsidian ネイティブ表現へ整形する。

## 適用範囲

- 入力: 構造を保った Markdown（タイトル + メタデータ箇条書き + セクション見出し + 画像 + 本文）。`article-summarizer` の出力フォーマットを主対象とする。
- 出力: Obsidian で開いて Properties / Wikilink / Callout / Tag が機能する Markdown。
- 非対応: HTML 由来のリッチコンテンツ（HTML タグ、生スタイル）。プレーン Markdown 化されている前提。

## ワークフロー

### Step 1: 入力解析

入力 Markdown を読み込み、以下の構造要素を抽出する。

- `# タイトル` 行
- 冒頭メタデータブロック（`- 情報源: ...`, `- 著者: ...`, `- 日付: ...`, `- 引用: ...` 等の箇条書き）
- セクション（`## 見出し`）と本文
- 画像 `![alt](path)` の位置と alt テキスト
- 引用ブロック（`> ...`）の有無
- 数式（`$...$`, `$$...$$`）の有無

ユーザーが明示的に保存先や追加要件（タグ追加、特定見出しの callout 化等）を指定している場合はメモする。

### Step 2: YAML frontmatter 化（決定的変換）

冒頭の箇条書きメタデータブロックを YAML frontmatter に変換する。マッピング規則と Properties の型は `references/conversion-rules.md` と `references/obsidian-syntax.md` を参照。

最低限のフィールド: `title`, `source`, `date`, `tags`。`author`, `aliases`, `created` は元 Markdown に存在すれば追加する。

frontmatter 化したメタデータは本文側からは削除する（重複させない）。`# タイトル` 見出しは frontmatter の直後に 1 度だけ残す（Obsidian は H1 を本文として表示するため）。

### Step 3: 埋め込み・リンク変換（決定的変換）

- 画像 `![alt](path)` → `![[path|alt]]`。alt が空の場合は `![[path]]`。外部 URL（`http://`, `https://`）の場合はそのまま標準 Markdown 形式を維持する（Obsidian の embed は Vault 内パスのみ対応）。
- 内部参照（同一 Vault 内ノートを指す Markdown リンク）が明示されている場合は `[[note]]` または `[[note#heading]]` 化する。元 Markdown に内部リンクが無い場合は何もしない。

### Step 4: 意味付与（判断ルール）

以下は Claude の判断で適用する。`references/conversion-rules.md` の判断指針に従う。

- タグ抽出: 記事の主題から 3〜5 個の話題を選び frontmatter の `tags:` リストに入れる。Obsidian の慣習に従い `area/topic` 形式のネストタグも検討する。
- Wikilink 候補: 記事内で 3 回以上出現するキー概念、または見出し化された固有用語を `[[キー概念]]` でリンク化する。一般語や代名詞には適用しない。
- Callout 化: 「まとめ／結論」セクションは `> [!summary]`、「注意／警告」は `> [!warning]`、「補足／メモ」は `> [!note]`、引用元情報は `> [!cite]` に変換する。元見出しの意味と一致しない場合は変換しない。

### Step 5: 自己検証

変換後の Markdown について、`references/conversion-rules.md` 末尾の「自己検証チェックリスト」（7 項目）を一通り確認する。未充足項目があれば該当箇所を再修正する。

数式（`$...$`, `$$...$$`）は Obsidian の KaTeX で互換のため変更不要。ただし `$$ ... $$` ブロックの前後に空行が無い場合は空行を追加する。

## 出力の保存

- ユーザーが保存パスを指定した場合はそれに従う。
- 指定が無い場合は、入力ファイル `foo.md` に対し `foo.obsidian.md` を同じディレクトリに作成する。元ファイルは上書きしない（差分確認できるようにする）。
- 画像ファイル本体は移動・改名しない。Vault 内の相対パスを保つよう、入力 Markdown 内のパスをそのまま `![[]]` の中身に流し込む。

## 参照ファイル

- `references/obsidian-syntax.md` — Obsidian 固有記法のチートシート。Properties 型、Wikilink、Embed、Callout 種別、ブロック参照、数式の書式を網羅。
- `references/conversion-rules.md` — `article-summarizer` 出力 → Obsidian 表現のマッピング表と自己検証チェックリスト。
- `references/examples.md` — before/after の具体例。標準的な技術記事とエッジケース（数式・引用多め）の 2 シナリオ。
- `references/validation.md` — `/empirical-prompt-tuning` を起動する際のシナリオ・チェックリスト・収束基準。スキル設計を改善・反復するときに使用する。

## スキル改善時のループ

スキル設計を改善・反復するときは `/empirical-prompt-tuning` を起動し、`references/validation.md` のシナリオ 3 件とロック済みチェックリストを評価者に渡す。連続 2 イテレーションで「新規 unclear ゼロ」かつ「精度改善 +3 ポイント以下」になったら収束とみなす。
