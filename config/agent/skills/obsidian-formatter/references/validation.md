# Validation Scenarios

`/empirical-prompt-tuning` で `obsidian-formatter` を評価するためのテンプレート。シナリオ・要件チェックリスト・収束基準・subagent 起動契約をロックして提供する。スキル設計を変えても、この validation 資材は固定したまま再評価する（軸を動かすと改善が測れなくなる）。

## シナリオ（ロック済み 3 件）

### Scenario A: 標準的な技術記事（中央値）

入力: `examples.md` の例 1 (Before) と同等構造のプレーン Markdown。

- メタデータ箇条書き 3 行（情報源・著者・日付）
- 通常セクション 3 つ（概要・実験設定・まとめ）
- 画像 2 枚（Vault 内相対パス）
- 引用元情報なし
- 数式なし

期待される出力: frontmatter + `# タイトル` + 通常セクション + `> [!summary]` callout + 画像が `![[]]` 形式。

### Scenario B: 引用 + callout 候補多めの記事

入力: `examples.md` の例 2 (Before) と同等構造。

- メタデータ箇条書き 5 行（情報源・著者・日付・引用 2 件）
- 通常セクション 1 つ + 「## 注意」セクション 1 つ
- 画像なし
- 数式 1 つ（display）+ インライン数式数個
- 引用 2 件

期待される出力: frontmatter + `# タイトル` + `> [!cite]` callout（引用 2 件統合）+ 通常セクション + `> [!warning]` callout + 数式が改行ありで保持。

### Scenario C: エッジケース（数式多め論文要約 + 外部 URL 画像）

入力: 論文要約。以下の条件を全部含む。

- メタデータ 4 行（情報源・著者・日付）
- 引用 1 件
- 通常セクション 4 つ（概要・手法・結果・まとめ）
- 画像 3 枚（うち 1 枚は外部 URL `https://...`、2 枚は Vault 内相対パス）
- インライン数式 5 個以上、display 数式 2 個以上
- 「## まとめ」セクションあり

期待される出力: 外部 URL 画像はそのまま標準 Markdown 形式、Vault 内画像は `![[]]` に変換。数式は KaTeX 互換のまま、`$$` 前後に空行。`> [!cite]` と `> [!summary]` callout が正しく配置される。

## 要件チェックリスト（シナリオ共通）

判定規則（○ / × / 部分的）は `/empirical-prompt-tuning` の「ワークフロー 4. 両面評価 / 指示側の計測」に従う。`[critical]` 印は最低ライン項目。

1. `[critical]` YAML frontmatter が valid（`---` で囲まれ、`title` / `source` / `date` / `tags` の 4 フィールドが必須、値の型が型推論ルールに沿う）
2. `[critical]` Vault 内パス画像が全て `![[]]` 形式に変換されている（外部 URL 画像は標準 Markdown 形式を維持）
3. `[critical]` `# タイトル` が frontmatter 直後に 1 度のみ出現し、本文中に重複していない
4. 引用元情報がある場合 `> [!cite]` callout になっている（引用が複数件なら 1 つの callout に統合可）
5. `tags` が 3〜5 個、Obsidian Tag 仕様（英数字 / `-` / `_` / `/`、数字のみ不可）に従い、frontmatter リスト内では `#` プレフィクスを付けない
6. 数式 `$$ ... $$` ブロックが KaTeX 互換のコマンドのみで構成され、前後に空行が確保されている
7. 元記事の本文情報が欠落していない（callout 化や frontmatter 化で本文から取り除いた箇所が、frontmatter または callout 内に存在する。差分検査で diff した際、情報の総量が保たれている）

## 収束基準

`/empirical-prompt-tuning` の「反復の打ち切り基準」に準拠しつつ、本スキルは Heavy-duty 扱いではないため連続 2 回でクリアとする。

連続 2 イテレーションで以下を全て満たすこと:

- 新規不明瞭点: 0 件
- 精度の前回比改善: +3 ポイント以下
- ステップ数の前回比変動: ±10% 以内
- duration の前回比変動: ±15% 以内
- 過適合チェック: 収束判定時に hold-out シナリオ 1 本（Scenario D, 後述）を追加実行し、精度が直近平均から 15 ポイント以上落ちないこと

### Scenario D: Hold-out（過適合チェック用）

評価ループ中は使わず、収束判定時のみ実行する。

入力条件: メタデータ 3 行 + 通常セクション 2 つ + Vault 内画像 1 枚 + 引用 1 件 + 数式なし + 「## まとめ」「## 注意」両方を含む。Scenario A〜C の組合せに当たらない構造。

## subagent 起動契約

`/empirical-prompt-tuning` の「subagent 起動契約」テンプレートに沿い、本スキル評価では以下の文面を渡す。

```
あなたは obsidian-formatter スキルを白紙で読む実行者です。

## 対象プロンプト
/Users/kitamura/.claude/skills/obsidian-formatter/SKILL.md
（references/ ディレクトリも必要に応じて読んでください）

## シナリオ
<Scenario A / B / C / D いずれかの入力 Markdown を全文貼り付け。
保存先指定は「同じディレクトリに *.obsidian.md として出力」。>

## 要件チェックリスト
1. [critical] YAML frontmatter が valid（`title` / `source` / `date` / `tags` 必須、型推論ルール準拠）
2. [critical] Vault 内パス画像が全て `![[]]` 形式に変換されている（外部 URL 画像は標準 Markdown 形式を維持）
3. [critical] `# タイトル` が frontmatter 直後に 1 度のみ出現し、本文中に重複していない
4. 引用元情報がある場合 `> [!cite]` callout になっている
5. `tags` が 3〜5 個、Obsidian Tag 仕様準拠、frontmatter リスト内では `#` プレフィクスなし
6. 数式 `$$ ... $$` ブロックの前後に空行があり、KaTeX 互換コマンドのみ
7. 元記事の本文情報が欠落していない（差分検査）

（判定規則は empirical-prompt-tuning「ワークフロー 4. 両面評価」節に一元定義）

## タスク
1. obsidian-formatter スキルに従い、シナリオの入力 Markdown を Obsidian 記法に変換し、`*.obsidian.md` として出力する。
2. 終了時に下記レポート構造で返答する。

## レポート構造
- 成果物: 変換後の Markdown 全文
- 要件達成: 各項目について ○ / × / 部分的（理由付き）
- 不明瞭点: SKILL.md / references/ で詰まった箇所、解釈に迷った文言（箇条書き）
- 裁量補完: 指示で決まっておらず自分の判断で埋めた箇所（箇条書き）
- 再試行: 同じ判断をやり直した回数とその理由
```

## 評価運用メモ

- シナリオ A〜C は同一の subagent では実行しない（バイアス除去のため、毎イテレーションで新規 dispatch）
- 並列実行可: 単一メッセージ内で 3 つの Agent 呼び出しを並べる
- メトリクス収集は Agent tool の usage メタ（`tool_uses`, `duration_ms`）から行う
- スキル本体（SKILL.md / references/）の修正は 1 イテレーション 1 テーマに留める。`obsidian-syntax.md` と `conversion-rules.md` を同時に書き換えると効果が分離できなくなる
- ロックされたシナリオ・チェックリストを評価途中で書き換えない（書き換えるなら baseline 取り直しから再開）
