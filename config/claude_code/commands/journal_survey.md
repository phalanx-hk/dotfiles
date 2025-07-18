# Claude コマンド: 論文調査

このコマンドは、論文のリンクを引数として受け取り、その論文を指定されたフォーマットに従ってまとめるためのスラッシュコマンドです。

## 使用方法

論文調査を実行するには次のように入力してください

```
/research-survey $ARGUMENTS
```

`$ARGUMENTS` には論文のURL（arXiv、IEEE、ACM、などの学術論文サイト）を指定します。

## このコマンドは以下の手順を実行します

1. 引数として渡された論文URL（$ARGUMENTS）を検証します
2. プロジェクトのルートディレクトリに `papers/` ディレクトリが存在しない場合は作成します
3. 論文URLから論文情報を取得します
4. WebFetchツールを使用して論文の内容を取得・分析します
5. 取得した情報を指定されたフォーマットに従って整理します
6. 論文タイトルをファイル名として `papers/{論文タイトル}.md` ファイルを作成・保存します

## 出力フォーマット

以下の構成で論文の内容をまとめます：

```markdown
# 論文タイトル

## 論文概要
どのような問題に対して、どのような研究をしたのか

## 先行研究との差分
- どのような問題があり、どのような提案をしたか

## 技術や手法のキモ
- 具体的にどのような技術や手法を提案したか
- 数式を用いて具体的で理解しやすい、かつ読者に分かりやすいようにまとめる

## どうやって有効と証明したか
- ざっくりとどのような検証を行なったか
```

## 処理フロー

### 1. URL検証と論文情報の特定
- 提供されたURLから論文情報を抽出
- arXivの場合はHTML版の利用可能性をチェック
- 論文タイトルと著者情報を取得

### 2. 論文内容の取得
- WebFetchツールを使用してHTMLコンテンツを取得
- PDFの場合は可能な限りテキスト情報を抽出
- 主要セクション（Abstract, Introduction, Method, Results, Conclusion）を特定

### 3. 内容の分析と整理
- 論文の主要な貢献を特定
- 先行研究との違いを明確化
- 提案手法の技術的詳細を抽出
- 実験結果と評価方法を整理

### 4. ファイル生成と保存
- 論文タイトルから適切なファイル名を生成（特殊文字の除去など）
- 指定フォーマットに従ってMarkdownファイルを作成
- `papers/` ディレクトリに保存

## 特殊な処理


- **無効なURL**: 論文サイトとして認識できないURLの場合はエラーメッセージを表示
- **アクセス不可**: 論文にアクセスできない場合（有料、制限等）の適切な処理
- **解析失敗**: 論文内容の解析に失敗した場合の代替手段の提案
- **ファイル書き込みエラー**: 保存時のエラーハンドリング

## 使用例

### arXiv論文の調査
```
/research-survey https://arxiv.org/pdf/2303.08774
```

## 注意事項

- 論文の著作権を尊重し、要約・分析の範囲での利用に留めます
- 有料論文の場合、アクセス可能な範囲（abstract等）での分析になります
- 生成されるファイル名は自動的にサニタイズされます（特殊文字の除去など）
- 既存の同名ファイルがある場合は上書き前に確認を行います
- 論文の内容が非常に長い場合は、重要な部分を優先して抽出します

## 出力ファイルの管理

### ファイル名の生成規則
- 論文タイトルを基にファイル名を生成
- 英数字、ハイフン、アンダースコアのみ使用
- 日本語タイトルの場合は適切な英語翻訳またはローマ字変換
- 最大ファイル名長制限への対応

### ディレクトリ構造
```
papers/
├── {論文タイトル1}.md
├── {論文タイトル2}.md
└── assets/
    └── images/     # 論文中の図表保存用（将来拡張）
```

## 今後の拡張可能性

- 複数論文の一括処理機能
- 論文間の関連性分析
- 図表の自動抽出と保存
- 引用情報の管理
- 論文データベースとの連携