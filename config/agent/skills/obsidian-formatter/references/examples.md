# 変換例

`article-summarizer` 出力 → Obsidian 記法の before / after。スキル適用時の期待出力像を具体化する。

---

## 例 1: 標準的な技術記事

メタデータ完備 + 画像 2 枚 + 通常セクションの典型例。

### Before (article-summarizer 出力)

```markdown
# In-Context Learning は何を学習しているのか

- 情報源: https://example.com/icl-analysis
- 著者: Jane Doe
- 日付: 2026-04-12

---

## 概要

In-Context Learning (ICL) は大規模言語モデルが推論時に few-shot 例から
学習するように振る舞う現象である。本記事では ICL がパラメータ更新を
伴わずにどのようにタスク適応するのかを実験的に分析する。

![ICL の入出力概念図](images/icl-overview.jpg)

## 実験設定

GPT-NeoX 20B を用いて、4 種類の合成タスクで 0-shot, 1-shot, 8-shot を比較した。
評価指標は accuracy と attention pattern の類似度である。

![Attention パターンの可視化](images/attention-heatmap.jpg)

## まとめ

ICL は few-shot 例の影響を attention 重みの変化として吸収しており、
パラメータは変わっていないが内部表現は明確に変化している。
今後の研究方向として、より長文脈での ICL 挙動の分析が挙げられる。
```

### After (Obsidian 記法)

````markdown
---
title: In-Context Learning は何を学習しているのか
source: https://example.com/icl-analysis
author: Jane Doe
date: 2026-04-12
tags:
  - llm
  - in-context-learning
  - research/analysis
---

# In-Context Learning は何を学習しているのか

## 概要

[[In-Context Learning]] (ICL) は大規模言語モデルが推論時に few-shot 例から
学習するように振る舞う現象である。本記事では ICL がパラメータ更新を
伴わずにどのようにタスク適応するのかを実験的に分析する。

![[images/icl-overview.jpg|ICL の入出力概念図]]

## 実験設定

GPT-NeoX 20B を用いて、4 種類の合成タスクで 0-shot, 1-shot, 8-shot を比較した。
評価指標は accuracy と attention pattern の類似度である。

![[images/attention-heatmap.jpg|Attention パターンの可視化]]

> [!summary]
> ICL は few-shot 例の影響を attention 重みの変化として吸収しており、
> パラメータは変わっていないが内部表現は明確に変化している。
> 今後の研究方向として、より長文脈での ICL 挙動の分析が挙げられる。
````

### 変換ポイント

- 冒頭の箇条書きメタデータを YAML frontmatter に変換
- タグ 3 個を主題から推定して frontmatter に追加（記事本文の主題は ICL = LLM の現象 = 研究分析）
- 画像 2 枚を `![[]]` 形式に変換（alt テキストはパイプ右側）
- ICL は記事中で 3 回以上出現する固有用語のため、初出のみ `[[In-Context Learning]]` 化
- 「## まとめ」セクションを `> [!summary]` callout に変換し、見出し自体は callout に吸収
- `# タイトル` は frontmatter 直後に 1 度だけ残す
- 区切り線 `---` は frontmatter と本文の役割が分離されたため削除

---

## 例 2: 引用 + 数式多めのエッジケース

引用 2 件 + LaTeX 数式 + 注意セクションを含む論文要約。

### Before

```markdown
# Diffusion Models のスケーリング則

- 情報源: https://arxiv.org/abs/2604.12345
- 著者: Lin Wei, Sara Cohen
- 日付: 2026-03-28
- 引用: Scaling Laws for Neural Language Models (Kaplan et al., OpenAI, 2020) https://arxiv.org/abs/2001.08361
- 引用: Chinchilla: Training Compute-Optimal Large Language Models (Hoffmann et al., DeepMind, 2022) https://arxiv.org/abs/2203.15556

---

## 主結果

著者らは画像生成 diffusion model の loss が以下の冪乗則に従うことを示した。

$$
L(N, D) = \left(\frac{N_c}{N}\right)^{\alpha_N} + \left(\frac{D_c}{D}\right)^{\alpha_D}
$$

ここで $N$ はパラメータ数、$D$ はデータ量、$\alpha_N \approx 0.34$、$\alpha_D \approx 0.41$ である。
LLM のスケーリング則 (Kaplan 2020) と比較すると、データ側の指数 $\alpha_D$ がやや大きい。

## 注意

本研究の実験はすべて 256x256 解像度で行われており、より高解像度での
スケーリング挙動は未検証である。Chinchilla (Hoffmann 2022) のような
compute-optimal な分析も未実施。
```

### After

````markdown
---
title: Diffusion Models のスケーリング則
source: https://arxiv.org/abs/2604.12345
author: Lin Wei, Sara Cohen
date: 2026-03-28
tags:
  - diffusion-model
  - scaling-laws
  - research/paper
---

# Diffusion Models のスケーリング則

> [!cite] 引用元
> Scaling Laws for Neural Language Models — Kaplan et al. (OpenAI, 2020)
> [https://arxiv.org/abs/2001.08361](https://arxiv.org/abs/2001.08361)
>
> Chinchilla: Training Compute-Optimal Large Language Models — Hoffmann et al. (DeepMind, 2022)
> [https://arxiv.org/abs/2203.15556](https://arxiv.org/abs/2203.15556)

## 主結果

著者らは画像生成 [[Diffusion Model]] の loss が以下の冪乗則に従うことを示した。

$$
L(N, D) = \left(\frac{N_c}{N}\right)^{\alpha_N} + \left(\frac{D_c}{D}\right)^{\alpha_D}
$$

ここで $N$ はパラメータ数、$D$ はデータ量、$\alpha_N \approx 0.34$、$\alpha_D \approx 0.41$ である。
LLM のスケーリング則 (Kaplan 2020) と比較すると、データ側の指数 $\alpha_D$ がやや大きい。

> [!warning]
> 本研究の実験はすべて 256x256 解像度で行われており、より高解像度での
> スケーリング挙動は未検証である。Chinchilla (Hoffmann 2022) のような
> compute-optimal な分析も未実施。
````

### 変換ポイント

- 2 件の引用を `> [!cite]` callout 1 つにまとめ（引用元情報をひとまとまりとして扱う）
- frontmatter には `source` と主要メタデータのみ。引用情報は callout に分離（記事自体の出典と引用論文を混同させない）
- 数式 `$$ ... $$` は前後の空行を保ち、KaTeX 互換コマンド（`\frac`, `\alpha`, `\approx`）をそのまま維持
- インライン数式 `$N$`, `$\alpha_D$` も変更なし
- "Diffusion Model" を初出で wikilink 化（タイトルと本文に複数回出現する固有用語）
- 「## 注意」セクションを `> [!warning]` callout に変換
- タグはネスト形式 `research/paper` を含めて 3 個

---

## 変換時に注意するパターン

- 元 Markdown のセクション順序は保つ（callout 化しても順序を入れ替えない）
- 引用ブロックが本文中に既に `> ...` で書かれている場合、それを callout 化するかは内容次第（出典情報なら `> [!cite]`、著者の主張引用なら `> [!quote]`）
- 数式中の `_` を Markdown のイタリックと誤認しない（`$x_i$` はそのまま）
- 画像ファイル名にスペースが含まれる場合は `![[my image.jpg|alt]]` でそのまま書ける（エスケープ不要）
