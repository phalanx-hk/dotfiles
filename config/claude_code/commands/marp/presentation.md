# Claude コマンド: Marp プレゼンテーション作成

このコマンドは、Marpライブラリを使用してプレゼンテーション資料の雛形を作成し、効率的なプレゼン資料作成を支援します。

## 使用方法

プレゼンテーション資料を作成するには次のように入力してください

```
/presentation $ARGUMENTS
```

## このコマンドは以下の手順を実行します

1. 引数として渡されたタイトル（$ARGUMENTS）を確認します（未指定の場合はユーザーに確認）
2. プロジェクトのルートディレクトリを確認します
3. marp-cliがインストールされているか確認し、未インストールの場合は自動インストール
  - `npm install -g @marp-team/marp-cli`を実行します
4. `presentations/`ディレクトリが存在しない場合は作成します
5. 以下のデフォルト設定でプレゼンテーション雛形を作成します：
   - theme: default
   - size: 16:9  
   - backgroundColor: #ffffff
   - paginate: true
   - header/footer: 不使用
6. プレゼンテーション資料の構成（タイトルスライド、アジェンダ、本編、まとめ）を自動生成します
7. marp-cli用の設定ファイル（`.marprc.yml`）が存在しない場合は生成します
   - この設定ファイルには、テーマや出力形式の設定が含まれます
8. プレゼンテーション作成のためのnpmスクリプトを`package.json`に追加します
9. 開発用のライブサーバーを起動（オプション）

## 生成されるファイル構成

```
presentations/
├── {YYYY-MM-DD_$ARGUMENTS}.md              # メインのプレゼンテーション資料
├── assets/                 # 画像やリソース用ディレクトリ
│   └── images/
└── output/                 # 生成されるHTML/PDF用ディレクトリ
```

## 生成される雛形のYAML設定

作成されるプレゼンテーションファイルには以下のYAML front matterが自動設定されます：

```yaml
---
marp: true
theme: default
paginate: true
size: 16:9
backgroundColor: #ffffff
---
```

## Marpの基本機能

生成される雛形には以下の要素が含まれます：

### スライド構成
- **タイトルスライド**
  - プレゼンテーションのタイトル（$ARGUMENTS）
  - 発表者名（雛形作成時はphalanx-hkと記載）
  - 日付（雛形作成時は現在の日付）
- **アジェンダ**: プレゼンテーションの流れ
- **本編スライド**: コンテンツ用のテンプレート（自動ページ番号付き）
- **まとめスライド**: 重要ポイントの振り返り

### スタイル設定（デフォルト設定）
- **テーマ**: default（Marpのデフォルトテーマを使用）
- **サイズ**: 16:9（ワイドスクリーン形式）
- **背景色**: #ffffff（白背景）
- **ページ番号**: true（自動ページ番号表示）
- **ヘッダー・フッター**: 不要（設定しない）

### Marp機能の活用
- **ページ番号**: 自動ページ番号表示
- **背景画像**: スライド背景のカスタマイズ
- **アニメーション**: シンプルなトランジション効果
- **数式表示**: LaTeX形式の数式サポート
- **コードハイライト**: プログラムコードの見やすい表示

## ビルドコマンド

### 直接marp-cliを使用：

```bash
# HTML形式で出力
marp presentations/{title}.md --html

# PDF形式で出力（高品質）
marp presentations/{title}.md --pdf --allow-local-files

# PowerPoint形式で出力
marp presentations/{title}.md --pptx

# 開発用サーバー起動（ライブリロード付き）
marp presentations/{title}.md --serve --watch

# カスタムテーマ付きで出力
marp presentations/{title}.md --theme custom.css --pdf
```

### 生成されるnpmスクリプト：

```bash
# HTML形式で出力
npm run marp:html

# PDF形式で出力  
npm run marp:pdf

# PowerPoint形式で出力
npm run marp:pptx

# 開発用サーバー起動（ライブリロード付き）
npm run marp:serve

# 全形式で一括出力
npm run marp:build

# 特定のファイルをライブプレビュー
npm run marp:dev -- presentations/{title}.md
```

## カスタマイズ可能な要素

### テーマのカスタマイズ
- カスタムCSS/SCSSスタイル
- レスポンシブ対応
- ダークモード対応

### レイアウトテンプレート
- タイトルページ
- セクション区切り
- 2カラムレイアウト
- 画像重視レイアウト
- コード表示レイアウト

### エクスポート設定
- 高解像度PDF出力
- スライドサイズの調整
- 印刷用レイアウトの最適化

## 使用例

### 技術プレゼンテーション
```
/presentation "マイクロサービス アーキテクチャの導入"
```

### ビジネスプレゼンテーション  
```
/presentation "四半期業績報告"
```

## ベストプラクティス

### コンテンツ作成
- **1スライド1メッセージ**: 各スライドで伝える内容を明確に
- **視覚的階層**: 見出し、本文、補足情報の階層を意識
- **適切な文字サイズ**: 会場の大きさに応じたフォントサイズ選択

### デザイン原則
- **一貫性**: 色、フォント、レイアウトの統一
- **シンプルさ**: 余白を活用した見やすいデザイン
- **コントラスト**: 文字と背景の十分なコントラスト確保

### 画像・グラフィック
- **高品質な画像**: 鮮明で適切なサイズの画像使用
- **著作権の確認**: 使用する画像の権利関係を確認
- **Alt テキスト**: アクセシビリティを考慮した代替テキスト

## marp-cliの追加機能

### 高度な出力オプション
```bash
# 高解像度PDF（プリント用）
marp input.md --pdf --pdf-notes --scale 2

# 複数ファイル一括変換
marp presentations/ --output output/ --pdf

# カスタム設定ファイル使用
marp input.md --config-file marp.config.js

# HTMLテンプレート指定
marp input.md --template custom-template.html
```

### 設定ファイル例（.marprc.yml）
```yaml
allowLocalFiles: true
engine: "@marp-team/marp-core"
html: true
pdf: true
pptx: true
watch: true
server: true
theme: 
  - custom.css
themeSet: themes/
```

## 注意事項

- marp-cliが未インストールの場合、自動的にインストールします（`npm install -g @marp-team/marp-cli`）
- 既存の`presentations/`ディレクトリがある場合は、既存ファイルを上書きしないよう確認します
- プレゼンテーションファイル名は自動的にサニタイズされます（特殊文字の除去など）
- 大容量の画像ファイルは`assets/images/`ディレクトリに配置することを推奨します
- PDF出力は内蔵のPuppeteerを使用するため追加設定不要です
- `--allow-local-files`オプションで画像などのローカルファイル参照が可能です

## 拡張機能

### プラグインサポート
- Marp CLI プラグインの活用
- カスタムディレクティブの定義
- 外部ツールとの連携

### CI/CD統合
- GitHub Actionsでの自動ビルド
- プレゼンテーション資料の自動公開
- バージョン管理とリリースノート生成