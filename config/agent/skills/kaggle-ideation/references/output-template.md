# 出力テンプレート

Phase 4 で生成する最終マークダウンの記入指針と完成例。以下 6 節を全て含むこと。

## 全体構成

1. **コンペ概要**: タスク／評価指標／データ規模／残期間／submission 残／計算リソース
2. **現状ベースライン**: 構成（単体 / アンサンブル）／CV / Public LB／CV-LB 信頼度
3. **仮説バックログ**: 10〜20 件、6 視点を含む表
4. **Recommended queue**: フェーズ別件数（序盤 5〜7／中盤 3〜5／終盤 1〜3／残 24h 未満 1 件 + backup）
5. **やらない仮説**: 殺した仮説と理由 1 行
6. **不明点**: 最低 1 件、空欄禁止

## 各節の書き方

### コンペ概要

Phase 1 で確定した内容を箇条書きで記載。

### 現状ベースライン

- baseline submit 済み・反復実験中: 構成詳細・CV / LB スコア・CV-LB 信頼度（整合 / 微乖離 / 大乖離）
- 未着手: 「未着手」と記載し、構成・スコア欄は空欄でよい

### 仮説バックログ

- 10〜20 件。中央値 12〜15 件。
- 表形式。Cost 昇順 × Impact カテゴリ多様性確保でソート。
- 各行に 6 視点（カテゴリ／Impact primary・tags／根拠／Cost／time-to-signal／バリデーション堅牢性／実装コスト／submission risk）と弱点（2 つ以上）を含める。
- 「仮説的（前例なし）」根拠の仮説は表外に補足ブロックを設け、(a) どの観察から生まれたか (b) 成功条件 (c) 30〜60 分の最小検証手順 (d) 失敗時に学べること、を箇条書きで併記する。

### Recommended queue

選定基準: Impact カテゴリ多様性 × Cost の安さ × 依存なし × time-to-signal の速さ × submission risk の低さ。

- 序盤: 5〜7 件
- 中盤: 3〜5 件
- 終盤: 1〜3 件
- 残 24h 未満 or submission 残少: 1 件 + backup submission 方針

各エントリは「(#番号) <仮説要約> — 理由: ...」形式。理由には、なぜ「**今**」やるべきかを 1〜2 行で書く（time-to-signal が速い／既存差替えで rollback 容易／diagnostic で次手を作る／アンサンブル多様性を補う／metric-alignment で底上げ など）。

**終盤ガード**: 残 1〜2 週間以内のフェーズで Recommended queue 上位に「重い新規学習」「大規模 NN 構造変更」「学習レシピの大幅変更」を置かない。置くなら本文中で「終盤としてはリスクが高いが、CV-LB が大乖離しており再設計が必要」のような明確な根拠を 1 行で添える。

### やらない仮説

仮説バックログから drop した、または優先度を意図的に下げた仮説を理由付きで列挙する。

- 形式: `(#X) <仮説要約> — 理由: <なぜやらないか 1 行>`
- 「観察由来を書けない仮説的」「終盤に重すぎる」「規約違反疑い」「効果見込み < 検証コスト」などが理由になる。
- HPO は対象外なので、HPO に関する要望が来ていればこの節で「対象外。Optuna 等の体系的探索を別途実施」と明記する。

### 不明点

- 現時点で未解決の論点を最低 1 件書く。「なし」と書かない。
- 候補: 「Phase 1 で聞ききれなかった追加情報」「データ規約の確認待ち」「discussion で議論中の論点」「外部データの利用可否」「計算リソースの上限」など。

## 完成例（中盤・画像分類コンペ・leak 疑いケース）

```markdown
# <コンペ名> 実験バックログ

## コンペ概要

- タスク: 画像分類（多クラス、医療画像）
- 評価指標: Macro-F1
- データ規模: 学習 50k 画像、テスト 20k 画像、クラス数 12（不均衡）
- 残期間: 10 日
- submission 残: 5 / 5 per day（current 残数余裕あり）
- 計算リソース: ローカル GPU（RTX 4090 × 1）、クラウド未契約

## 現状ベースライン

- 構成: EfficientNet-B3 × 5-fold StratifiedKFold（単体、blend なし）
- CV / Public LB: CV 0.78 / Public LB 0.73
- CV-LB 信頼度: **大乖離**（0.05 差）。discussion に「target leak 疑い」の投稿あり

## 仮説バックログ

| # | 仮説 | カテゴリ | Impact (primary / tags) | 根拠 | Cost | time-to-signal | バリデーション堅牢性 | 実装コスト | submission risk | 弱点（2 つ以上） |
|---|------|---------|------------------------|------|------|----------------|--------------------|-----------|-----------------|-----------------|
| 1 | Adversarial Validation で train/test 分布差を測る | データ健全性 | diagnostic / quick-win, low-risk | データ観察（CV-LB 0.05 乖離） | 30 分 | 数分 | CV-LB 整合維持 | 既存差替え | 低 | ・shift 検出だけでは原因特定に至らない／・AUC が低くても leak 残存の可能性 |
| 2 | discussion 指摘の leak 候補列を train/test で比較し隔離 | データ健全性 | robustness / quick-win | データ観察（discussion 投稿） | 30 分 | 数分 | CV-LB 整合維持 | 既存差替え | 低 | ・指摘が誤っている可能性／・隔離後にスコアが落ちうる |
| 3 | StratifiedKFold → StratifiedGroupKFold（patient_id でグループ化） | CV 戦略 | robustness | 過去解法（医療画像で頻出） | 数時間 | 全 fold 必要 | リーク・分布乖離懸念（旧 CV） | 中規模実装 | 低 | ・OOF 全再計算で時間ロス／・新 CV が LB と乖離するリスク |
| 4 | EfficientNet-B3 → ConvNeXt-Small に置換 | モデル視点 | ensemble-diversity | 過去解法 | 半日以上 | 全 fold 必要 | 過学習リスク中 | 中規模実装 | 中 | ・推論時間増／・blend 多様性の検証コストが大きい |
| 5 | 補助タスクとして年齢回帰を multi-task で同時学習 | ⑧学習戦略 | score-lift / infra-heavy | 仮説的（前例なし） | 半日以上 | 全 fold 必要 | 過学習リスク中 | 中規模実装 | 中 | ・補助タスクが主タスクを引きずる可能性／・OOF が安定しないかも |
| 6 | TTA（horizontal flip + 5-crop）導入 | ⑧学習戦略 | score-lift / postprocess, low-risk | 過去解法 | 30 分 | 1 fold で判明 | CV-LB 整合維持 | 既存差替え | 低 | ・推論時間 5x／・効果がデータ依存 |
| 7 | Pseudo labeling（confidence ≥ 0.95 のみ、1 iter） | ⑧学習戦略 | score-lift / infra-heavy | 過去解法 | 半日以上 | 全 fold 必要 | 過学習リスク中 | 中規模実装 | 中 | ・誤ラベル増殖リスク／・leak 疑い解消前は危険 |
| 8 | クラス不均衡対策で focal loss + class weight | ロス・指標整合 | metric-alignment | 理論的 | 数時間 | 1 fold で判明 | CV-LB 整合維持 | 既存差替え | 低 | ・F1 直結ではない／・α/γ 調整が必要 |
| 9 | OOF residual の大きい上位 200 サンプルを目視で label noise チェック | データ健全性 | diagnostic / quick-win | データ観察 | 30 分 | 数分 | CV-LB 整合維持 | 既存差替え | 低 | ・目視判断のばらつき／・noise 検出後の対処（再ラベル / 除外）が別途必要 |
| 10 | 上位 1st solution の Augmentation レシピを移植（cutmix + RandAugment） | ⑧学習戦略 | score-lift | 過去解法 | 数時間 | 1 fold で判明 | CV-LB 整合維持 | 既存差替え | 低 | ・既存 augmentation との重複でかえって正則化過多／・学習時間増 |
| 11 | LightGBM メタモデルで画像 embedding + メタ特徴の stacking | モデル視点 | ensemble-diversity | 過去解法 | 数時間 | 1 fold で判明 | 過学習リスク中 | 中規模実装 | 低 | ・OOF embedding の作成が必要／・leak リスク（fold 越境） |
| 12 | threshold tuning（クラスごとに F1 最大化閾値を OOF で探索） | ロス・指標整合 | metric-alignment / postprocess, quick-win | 理論的 | 30 分 | 1 fold で判明 | CV-LB 整合維持 | 既存差替え | 低 | ・public/private 分布差で閾値が崩れるリスク／・効果がデータ依存 |
| 13 | EfficientNet seed 違い 3 つで blend | モデル視点 | ensemble-diversity / postprocess | 過去解法 | 数時間 | 全 fold 必要 | CV-LB 整合維持 | 既存差替え | 低 | ・diversity が低く blend 効果が小さい／・学習時間 3x |
| 14 | mixup 導入（α=0.4） | ⑧学習戦略 | score-lift | 理論的 | 数時間 | 1 fold で判明 | CV-LB 整合維持 | 既存差替え | 低 | ・損失関数の調整が必要／・F1 評価との整合は弱い |

### 補足: 「仮説的」根拠の仮説について

#### #5 補助タスク年齢回帰

- 観察由来: discussion に「画像メタデータに年齢が含まれる」との投稿。OOF residual の上位に高齢サンプルが集中している
- 成功条件: 主タスクの CV macro-F1 が +0.005 以上、年齢 MAE が単独学習比 1.2 倍以内
- 最小検証手順: 1 fold で 30 epoch 学習、補助タスク重み 0.1 で固定、主タスク CV と年齢 MAE を比較
- 失敗時の学び: 「補助タスク重みが主タスクを引きずる」「年齢シグナルは画像分類に補助情報として効かない」のいずれかが分かる

## Recommended queue

中盤・残 10 日・submission 残数余裕ありのフェーズ。**leak 疑いを先に解消し、CV-LB を整合させる**ことを最優先に置く（CV が信頼できないと他の発散が空転する）。

1. **(#1) Adversarial Validation で train/test 分布差を測る** — 30 分・数分で signal、CV-LB 大乖離の原因切り分けに必須。`diagnostic` で次手の意思決定材料を作る
2. **(#2) discussion 指摘の leak 候補列を隔離** — 30 分・数分で signal、`robustness`。隔離後に CV が落ちても LB が改善するか確認する
3. **(#3) StratifiedGroupKFold（patient_id 単位）に切替** — 数時間。CV 設計の修正は後回しにすると後段の発散が無価値になるため、leak 検証と並行して実施
4. **(#9) OOF residual 大の label noise チェック** — 30 分・数分。leak とは別軸で CV を歪めている可能性を切り分け
5. **(#12) threshold tuning** — 30 分、`metric-alignment / postprocess`。低コストで Macro-F1 に直結
6. **(#6) TTA 導入** — 30 分・1 fold で signal、`postprocess`。既存差替えで rollback 容易

queue に入れなかった #4・#5・#7・#11 は、**CV-LB 整合が確認できてから**着手する（順序が逆だと leak で結論が歪む）。

## やらない仮説

- (#13) seed 違い blend のみ — diversity が低く、ensemble-diversity を狙うなら #4 ConvNeXt や #11 LightGBM stacking の方が期待値が高い
- HPO（learning rate / batch size / weight decay の体系的探索） — 対象外。leak 解消・CV 設計確定が先。やるなら別途 Optuna 等で実施
- 大規模事前学習モデル（ConvNeXt-Large / ViT-L など）の新規導入 — 推論時間が submission 制限を超えるリスク。`infra-heavy` で残期間に対して投資効率が悪い
- LB probing（特定サンプルの正解を 1 行ずつ submit して当てに行く） — submission 残を消費し、private LB で全く効かない

## 不明点

1. discussion で指摘されている leak 候補列の具体名が確定していない（最新コメントを拾い直す必要）
2. 患者 ID（patient_id）が dataset 内で正しく付与されているか未確認。重複チェックが必要
3. public LB のサンプル数が test 全体の何 % か未確定。public/private gap の見積りが取れない
4. 外部画像データセット（NIH ChestX-ray など）の利用可否がコンペ規約で明記されているか
5. 終盤に向けたアンサンブル候補（#4 ConvNeXt、#11 LightGBM stacking）のうち、どちらを優先するかの判断は #1〜#3 の結果次第
```

## 注意

- 上記は構成見本であって、正解の文面ではない。Phase 1〜3 で確定した内容に基づき、毎回新規に書く。
- 6 節の順序を変えない（読み手が探しやすいように固定）。
- 各節の見出しレベルは `##` で揃える。サブ要素のみ `###` または箇条書きで表現する。
- フェーズに応じて Recommended queue の件数を調整する（序盤 5〜7／中盤 3〜5／終盤 1〜3／残 24h 未満 1 件 + backup）。
- 終盤・残 24h 未満では、Recommended queue 上位に「重い新規学習」「大規模 NN 構造変更」を置かない。
- `submission-strategy` カテゴリは終盤・残 24h 未満で特に重要。提出 sanity check／final 2 つの選定／seed・fold 選別を含める。
