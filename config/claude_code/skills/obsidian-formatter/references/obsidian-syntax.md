# Obsidian 記法チートシート

Obsidian の独自 Markdown 拡張をスキル内で使うための簡易リファレンス。Obsidian 1.4+ を前提とする。

## YAML Properties (frontmatter)

ファイル先頭の `---` で囲まれた YAML ブロック。Obsidian は値を Properties として GUI に表示し、検索・ソートに利用する。

### 型推論

Obsidian は値の形から型を推論する。明示的な指定はない。

| 形 | 推論される型 |
|---|---|
| `text: 任意の文字列` | text |
| `count: 42` | number |
| `published: true` | checkbox |
| `due: 2026-05-08` | date |
| `start: 2026-05-08T09:00` | datetime |
| `tags: [a, b]` または `tags:\n  - a\n  - b` | list |

`tags` フィールドはリスト型扱いで Tag pane に集約される。

### 標準 Properties 名

Obsidian および主要コミュニティプラグインで意味付けされる名前。

- `tags`: ノートのタグ（`#` 不要、文字列値のリスト）
- `aliases`: 別名（リンク補完で代替検索される）
- `cssclasses`: CSS スニペット適用用クラス
- `publish`: Obsidian Publish 公開フラグ
- `permalink`: Obsidian Publish の URL スラグ

### 例

```yaml
---
title: 記事タイトル
source: https://example.com/article
author: 著者名
date: 2026-05-08
tags:
  - llm
  - prompt-engineering
  - research/eval
aliases:
  - 記事略称
---
```

## Wikilinks (内部リンク)

Vault 内の他ノートへのリンク。Obsidian は `[[]]` 内をノート名で解決する。

| 記法 | 意味 |
|---|---|
| `[[note]]` | `note.md` へのリンク。表示テキストは "note" |
| `[[note\|別名]]` | リンク先は同じ、表示は "別名" |
| `[[note#見出し]]` | `note.md` の指定見出しへ |
| `[[note#^block-id]]` | `note.md` の指定ブロック参照へ |
| `[[#見出し]]` | 同一ノート内の見出しへ |
| `[[#^block-id]]` | 同一ノート内のブロック参照へ |

ファイル名衝突がある場合はサブディレクトリパスを含めて `[[folder/note]]` と書く。

## Embeds (埋め込み)

`!` プレフィクスでリンク先のコンテンツをノート内に展開する。

| 記法 | 意味 |
|---|---|
| `![[note]]` | ノート全文を埋め込む |
| `![[note#見出し]]` | 指定見出しのセクションを埋め込む |
| `![[note#^block-id]]` | 指定ブロックを埋め込む |
| `![[image.png]]` | 画像を表示 |
| `![[image.png\|400]]` | 横幅 400px で表示 |
| `![[image.png\|alt text]]` | alt テキスト付き |
| `![[file.pdf]]` | PDF を埋め込み |

画像の `|` の右側は、数値または `NxN` 形式（例: `400x300`）の場合はサイズ指定（横幅または横×縦のピクセル）、それ以外の文字列の場合は表示テキストとして扱われる。

## Tags

ノートに付与するタグ。本文中の `#tag` または frontmatter の `tags:` リスト。

- 本文記法: `#area`, `#area/sub`, `#area/sub/leaf`（ネスト可）
- frontmatter 記法: `tags: [area, area/sub]`（`#` 不要）
- 使用可能文字: 英数字、`-`、`_`、`/`（ネスト区切り）。スペース・記号は不可
- 数字のみのタグ（`#2026`）は不可。文字を含める

## Callouts (コールアウト)

`> [!type]` で始まる引用ブロック。装飾された注意ボックスとして描画される。

### 構文

```markdown
> [!note]
> 本文。
> 複数行可能。

> [!warning] カスタムタイトル
> タイトルを上書きできる。

> [!summary]+
> `+` で初期展開、`-` で初期折りたたみ。
```

### 主な type

| type | 用途 |
|---|---|
| `note` | 一般メモ |
| `info` | 情報 |
| `tip` / `hint` | ヒント |
| `summary` / `tldr` | 要約・結論 |
| `abstract` | 抄録 |
| `example` | 具体例 |
| `quote` / `cite` | 引用元情報 |
| `warning` / `caution` | 注意・警告 |
| `danger` / `error` | 危険・エラー |
| `bug` | 既知のバグ |
| `success` / `check` / `done` | 完了・成功 |
| `question` / `help` / `faq` | 疑問・FAQ |
| `failure` / `fail` / `missing` | 失敗・欠落 |

未知の type を指定した場合は `note` にフォールバックする。

## Block References

段落・リスト項目末尾に `^id` を付けるとブロック ID が定義される。他ノートから `[[note#^id]]` で参照できる。

```markdown
これは参照対象の段落である。 ^key-claim

参照側: [[source-note#^key-claim]]
```

ID は英数字とハイフンで構成し、6 文字以上を推奨。

## Math (KaTeX)

Obsidian は KaTeX で数式をレンダリングする。

- インライン: `$E = mc^2$`
- ディスプレイ: 独立行に `$$ ... $$`。前後に空行を置くこと

```markdown
ここで $\nabla f$ を考える。

$$
\sum_{i=1}^{n} x_i = \mu
$$
```

LaTeX コマンドは KaTeX サポート関数のみ使用可能（`\frac`, `\sum`, `\int`, `\mathcal`, `\mathbb`, `\mathrm`, `\hat`, `\theta` 等は OK）。`\require` や `\newcommand` の一部は非対応。

## エスケープと注意点

- `[[`, `]]`, `![[` をリテラル表示したい場合はバックスラッシュエスケープ（`\[\[`）
- ファイル名にスペースを含む場合 `[[my note]]` とそのまま書ける
- `|` をリンクのエイリアス区切り以外で使うときは `\|`
- frontmatter 内で `:` を含む文字列はクォートで囲む（`title: "a: b"`）
