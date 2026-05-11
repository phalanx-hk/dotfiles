---
name: article-summarizer
description: "URLで指定されたWebページ（ブログ記事、X/Twitterポスト、技術記事、論文ページ等）の内容を調査・要約し、マークダウンファイルとしてまとめるスキル。記事内で引用・参照されている外部リンクの内容も追跡して含める。ページ内の画像も元URLから直接ダウンロードしてJPEG圧縮して保存する。トリガー: ユーザがURLを提示して「まとめて」「要約して」「内容を調査して」「ファイルに保存して」と依頼したとき。"
---

# Article Summarizer

## ワークフロー

### Step 1: 記事本文の取得

ツール選択の優先順位:

1. WebFetch を試みる（高速・軽量）
2. 失敗した場合（402, 403, 認証が必要な場合）は agent-browser にフォールバック
   - 例外: 403 が返っても同等コンテンツが別 URL（GitHub 等）で入手可能な場合は WebFetch で代替し、agent-browser は不要

X/Twitter の URL は WebFetch が使えないため、最初から agent-browser を使う。
agent-browser でもログインウォールが返る場合は、nitter 等の代替フロントエンドを WebFetch で試みるか、WebSearch で第三者引用記事を探してフォールバックする。

agent-browser での全文取得:

```bash
agent-browser open "URL"
agent-browser snapshot          # 全文取得
# コンテンツが多い場合はスクロールして分割取得
agent-browser scroll down 2000
agent-browser snapshot
```

snapshotの出力が大きい場合（persisted-outputとして保存される場合）は Read ツールでファイルを読む。

### Step 2: 参照リンクの追跡

記事内で引用・参照されているURLを特定し、その内容も取得する。

追跡対象の優先度（高い順）:
1. 本文内で著者が明示的に言及・引用している記事・論文・ツイート
2. arXiv・研究論文の直接リンク
3. 著者自身の関連記事・リポジトリ

追跡対象外（省略してよい）:
- スポンサーリンク・広告・ナビゲーションリンク
- 公式サイトトップ（例: github.com, twitter.com）
- 本文の論旨と無関係な外部ツール紹介

上記優先度 1〜3 の中でも、本文で複数段落にわたって解説・引用されているものを優先し、一文以下しか触れていないものは省略可。
WebFetchで取得できない場合はWebSearchで記事タイトル等で検索してURLを特定してから agent-browser で取得する。

### Step 3: 画像の取得

スクリーンショットではなく、ページに埋め込まれた画像を直接ダウンロードする。

```bash
# ページHTMLから画像URLを抽出
curl -s "URL" | grep -oE 'src="[^"]*\.(png|jpg|jpeg|gif|svg|webp)[^"]*"' | sort -u

# 画像をダウンロードしてJPEGに変換・圧縮（quality 85）
# macOS の場合（sips が標準インストール済み）
curl -sL "https://..." -o /tmp/img_orig && sips -s format jpeg -s formatOptions 85 /tmp/img_orig --out images/figure1.jpg

# Linux / ImageMagick がある場合
# curl -sL "https://..." | convert - -quality 85 images/figure1.jpg
```

画像URLが見つからない場合（JS動的ロード等）は agent-browser で取得してページソースを検索:

```bash
agent-browser open "URL"
# ブラウザのDOMから取得できる場合
```

### Step 4: マークダウンファイルの作成

`documentation` スキルを使ってマークダウンファイルを作成する。

documentationスキルへの指示には以下を含める:
- 取得した記事本文・参照リンクの内容
- 保存先パス（ユーザが指定した場所、または現在のプロジェクトの適切なディレクトリ）
- 以下のファイル構成に従うこと

ファイル構成:

```markdown
# タイトル

- 情報源: URL
- 著者: 名前
- 日付: YYYY-MM-DD
- （引用記事があれば）引用: タイトル (著者, 媒体, 日付) URL

---

## セクション1

内容...

![図の説明](images/figure1.jpg)

## セクション2

...
```

注意事項:
- 画像は `![説明テキスト](images/ファイル名.jpg)` 形式で適切な位置に挿入する
- 引用記事がある場合は別セクションとして追記する
- 数式は LaTeX 記法で記載する。インライン数式は `$...$`、ディスプレイ数式（独立行の式）は `$$...$$` を使う
- 数式中のギリシャ文字・添字・演算子は LaTeX コマンド（例: `\pi`, `\theta`, `\mathcal{E}`, `\hat{A}_i`, `\mathbb{E}`, `\mathrm{clip}`）で書く。プレーン Unicode（π, θ, ℰ など）や ASCII 風表記（`A_i`, `pi_theta`）を数式部分に使わない

### Step 5: 確認

作成したファイルをユーザに報告し、追加で取得・詳細化が必要な箇所を確認する。
