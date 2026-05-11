# 発散の 8 観点

Phase 2 で 10〜20 件の仮説を生成する際に参照する 8 つの発想観点。これらは仮説を創出するための補助線であり、「何軸使う」「何軸にまたがる」といった必須制約は設けない。仮説が同じ方向に偏らないよう、観点を見渡してから発想する。

## ① データ視点

ガイド: 与えられたデータに含まれていないシグナル・既知の補助情報・サンプル間関係を持ち込む／切り出す。

- 変換例:
  - 外部データ（OpenStreetMap・公開ベンチマーク・テキストコーパス・天候データ）を結合
  - メタ特徴（元ファイル名・取得時刻・ID 区間）からのシグナル抽出
  - 時系列データを「縦持ち（1 行 = 1 イベント）」と「横持ち（1 行 = 1 ID × 全期間）」で切り替える
  - ID-level 統計（ユーザ単位・店舗単位・地域単位の集約特徴）
- 切り口: 外部データ可否（規約確認）、メタ特徴、サンプル間関係（group/sequence）、欠損パターン

アンチパターン: ライセンス・規約に違反する外部データを前提にする／discussion で「使えない」と確定したものを採用候補に残す。

## ② モデル視点

ガイド: 単に「別モデル試す」ではなく、**現状アンサンブルに不足している予測の出方**を補うモデルを選ぶ。アンサンブル多様性が中核。

- 変換例:
  - GBT 系（LightGBM / XGBoost / CatBoost）の使い分け（カテゴリ処理／欠損処理／葉成長戦略の違い）
  - NN 系（MLP / TabNet / FT-Transformer / 1D-CNN）への切り替え
  - Linear（Ridge / Lasso / ElasticNet）でアンサンブル底上げ
  - SVM・k-NN・ルールベースで多様性追加
  - Stacking 構造の変更（OOF メタ特徴の階層化、L2 メタモデル種別の入替）
  - MoE（Mixture of Experts）で ID 群別に学習器を分ける
- 切り口: 予測分布の形（log scale / sigmoid / monotonic / piecewise）、誤りパターンの相関、推論コスト

アンチパターン: 既にアンサンブルしているモデルと相関の高いモデルを足すだけ（多様性が出ない）／推論時間が submission 制限を超えるモデルを終盤に新規投入。

## ③ 前処理・特徴量変換

ガイド: 元の入力を別表現に変換し、モデルが拾えるシグナルを増やす。target / 高基数カテゴリ・null パターンが主戦場。

- 変換例:
  - target encoding（K-Fold、smoothing 強度、leak 防止）
  - feature interaction（多項式・cross feature・対数比・差分）
  - embedding（カテゴリの埋め込み学習・事前学習済み embedding 流用）
  - 異常値処理（winsorize / log1p / rank-Gauss）
  - null パターン（null そのものを特徴に・null 群でモデル分離）
- 切り口: 高基数カテゴリ、欠損、スケールの偏り、時間依存特徴（lag / rolling）

アンチパターン: target encoding を fold 越境で計算（leak）／PCA で情報を潰しすぎる／前処理を train/test で別々に fit。

## ④ CV 戦略

ガイド: CV と LB の整合を最優先。整合が崩れると「効いた／効かない」が判定不能になり、すべての発散が無価値になる。

- 変換例:
  - GroupKFold（同一ユーザ・同一店舗を fold 越境させない）
  - StratifiedKFold（少数クラスの fold 内割合を保つ）
  - TimeSeriesSplit（学習区間 < 検証区間の時間順序を守る）
  - Nested CV（ハイパラ選定と性能推定を分離）
  - OOF 安定性確認（複数 seed で OOF score の分散を測る）
  - **Adversarial Validation**（train/test の分布差を検出）
- 切り口: サンプル独立性（i.i.d. か）、時間順序、グループ構造、public/private split の推測

アンチパターン: shuffle KFold で sample 同士の依存（時系列・group）を無視／public LB に CV を合わせ込みすぎて private で崩れる。

## ⑤ ロス・指標整合

ガイド: 評価指標と直結したロス・後処理を選ぶ。「学習指標と評価指標が違う」場合の埋め合わせが score lift に直結する。

- 変換例:
  - QWK（Quadratic Weighted Kappa）→ 順序回帰として regression＋threshold tuning、または ordinal target に変形
  - MAP@K → ranking loss（pairwise / listwise）、negative sampling 設計、calibration
  - F1 → threshold tuning（fold ごとに最適閾値を OOF で確定）
  - AUC → calibration（Platt scaling / isotonic）、class weight
  - RMSLE → log1p 変換 → MSE で学習 → expm1 で逆変換
- 切り口: 学習ロス vs 評価指標の差、サンプル重み、threshold tuning、ranking head 設計

アンチパターン: 評価指標が QWK なのに MAE/MSE で学習＋後処理なし／class imbalance を無視して accuracy 最適化。

## ⑥ 上位解法転用

ガイド: 過去の類似コンペ（同 modality / 同タスク種別 / 類似評価指標）の上位 discussion・write-up を読み、解法を移植する。

- 変換例:
  - 過去 1st solution の特徴量設計をそのまま試す
  - 過去 Top discussion の Augmentation 戦略を移植
  - 過去 silver/gold solution の stacking 構造を流用
- 切り口: 同一モダリティ・同一指標の過去コンペ、Kaggle 以外（arXiv / SOTA paper）からの転用

アンチパターン: 「過去コンペで効いた」という言葉だけで選び、なぜ効いたかの仮説が不明なまま採用／対象タスクとの差を吟味せず移植。

## ⑦ データ健全性（独立観点）

ガイド: leak / duplicate / distribution shift / public-private gap / label noise を「先に検出する」。これを欠くと他の発散がすべて空転する。**序盤・中盤の最重要観点**。

- 変換例:
  - leak 検出（サンプル ID と target の相関、行番号と target の相関、未来情報の混入）
  - duplicate 検出（完全一致／near-duplicate／hash 一致）
  - distribution shift 検出（**Adversarial Validation**：train vs test 二値分類で AUC が 0.7 を超えたら shift あり）
  - public-private gap 仮説（public LB の評価サンプル数推定、time-based split の推測、サンプルカバレッジ確認）
  - label noise（OOF residual の大きいサンプルを抽出して目視）
- 切り口: leak の有無、shift 軸（時間 / 地理 / カテゴリ）、public LB のカバレッジ、ラベルの信頼度

アンチパターン: leak を「使う」方向で発散する（**leak は検出・隔離・public/private risk を測ることが目的**。LB only に効く加工は private で崩れる）／adversarial AUC が低くても安心して shift を考えない。

## ⑧ 学習戦略・表現学習

ガイド: 通常の supervised learning に加え、データ・ラベルの使い方を変える戦略群。NN 系で特に効きやすい。

- 変換例:
  - **Pseudo labeling**（test に予測ラベルを付けて再学習。confidence 閾値・iter 回数を調整）
  - **mixup / cutmix**（入力＋ラベル線形補間で正則化）
  - **TTA（Test Time Augmentation）**（推論時に複数 augmentation で平均）
  - **Knowledge distillation**（大モデル → 小モデルへ予測確率を蒸留）
  - **Multi-task learning**（補助タスクを同時学習）
  - **Curriculum learning**（易→難サンプル順に学習）
  - **Contrastive learning**（SimCLR / SimSiam ベースの表現事前学習）
  - **Semi-supervised**（FixMatch / MixMatch）
  - **LLM as feature extractor**（LLM 埋め込みを特徴量化、または zero/few-shot で予測）
  - **Prompting**（LLM に対するプロンプト設計をサンプル特性に合わせる）
- 切り口: ラベル付き／なしデータの量、NN の事前学習有無、推論コストの余裕

アンチパターン: pseudo labeling を 1 iter の confidence 閾値なしで回す（誤ラベルが増殖）／TTA を CV/LB の整合確認なしで導入／distillation を baseline 未確立段階で先行。

## 共通アンチパターン

- **HPO で仮説を埋める**: ハイパラ最適化は対象外。Optuna 等の体系的探索は別ツール。HPO 由来の仮説を backlog に出さない。
- **「○○を試す」で終わる**: 何の指標・観察を改善するための仮説か、根拠カテゴリ（過去解法／理論的／データ観察／仮説的）を 1 行で書けないなら採用しない。
- **「仮説的（前例なし）」根拠の濫発**: 観察由来を書けないものは drop。残す場合は (a) どの観察から生まれたか (b) 成功条件 (c) 30〜60 分の最小検証手順 (d) 失敗時に学べること、の 4 行を必須とする。
- **同方向の仮説が並ぶ**: 8 観点を見渡さず、似た角度の発想ばかりが残ると多様性が出ない。
- **月並み仮説を残す**: baseline 既知手・「○○を試す」だけは捨てる。残すのは尖ったもの。
- **leak を「使う」方向に発散する**: 検出・隔離・public/private risk の評価が目的。LB に効くだけの加工は private で崩れる。

## 現状フェーズ別の重み・禁止事項

| フェーズ | 重点観点 | 推奨される仮説の質 | 禁止 / 抑制 |
|---|---|---|---|
| **序盤**（未着手 / baseline submit 直後） | ⑥上位解法転用・⑦データ健全性（CV 設計確定）・①データ視点 | CV 設計の確定／データ理解／baseline 候補のショート選定 | 凝った学習戦略（pseudo / distillation 等）を baseline 確立前に投入 |
| **中盤**（baseline 後の本格反復） | ⑦データ健全性（leak / shift 検証）・③特徴量変換・⑧学習戦略 | shift 検出・特徴量積み増し・学習戦略導入で score-lift と robustness を両立 | アンサンブル過多（多様性なき積み増し）／CV 設計の頻繁な変更 |
| **終盤**（残 1〜2 週間以内） | ②モデル視点（アンサンブル多様性）・⑤後処理 | アンサンブル weight 調整／calibration／threshold tuning／seed・fold 選別／提出 sanity check | **重い新規学習・大規模 NN 構造変更**／**学習レシピの大幅変更**／submission 残数を消費する LB probing |
| **残 24h 未満** | ⑤後処理・submission strategy | 既存 OOF を使った post-hoc 調整・最終 submission 選定（diverse な 2 つを残す）・backup submission 確保 | **新規学習一切**／threshold 過適合（local 検証なし）／「ワンチャン」狙いの単発追加 |

HPO は全フェーズで対象外。組み込むなら不明点 / やらない仮説欄でその旨を述べる。
