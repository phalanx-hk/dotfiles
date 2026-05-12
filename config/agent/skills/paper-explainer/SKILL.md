---
name: paper-explainer
description: Read academic papers from local raw/papers entries, arXiv/HTML/PDF sources, or provided URLs; create detailed Japanese Markdown explanations with formulas, figures, experimental results, limitations, and Obsidian/MathJax compatibility checks. Use when the user asks to read, explain, summarize, or turn a paper into an Obsidian-ready Markdown note.
---

# Paper Explainer

Create a detailed Japanese paper explanation note from a local paper stub, arXiv page, HTML paper, PDF, or URL. Optimize the final Markdown for Obsidian reading.

## Workflow

### 1. Identify the Paper

- Inspect `raw/papers` recursively first when the user says they added a paper there; paper stubs may live in subdirectories such as `raw/papers/inbox/`.
- Prefer the newest or explicitly named file, but verify by reading the file and checking title, URL, abstract, and modification time.
- If the local file only contains metadata or an abstract, fetch the full HTML/PDF from the cited source.
- Use official or primary sources where possible: arXiv abs/html/pdf, publisher HTML, project page, or paper PDF.
- Resolve local source paths from the paper stub's directory first. For example, if `raw/papers/foo.md` says `HTML: ../../sources/foo.html`, interpret that path relative to `raw/papers/foo.md`, not the shell's current working directory.

### 2. Read the Full Paper

- Read the HTML version when available because it preserves headings, tables, equations, figure captions, and references better than a raw abstract.
- Extract at least: title, authors, date/version, abstract, problem setting, method, key equations, algorithms, experiments, ablations, results, qualitative examples, and limitations.
- Treat figure captions and tables as first-class evidence; do not rely only on the abstract.
- When the paper is long, inspect the table of contents first, then read method, experiment, and appendix sections relevant to implementation details and numeric claims.

### 3. Collect Figures

- Use figures when text or equations alone would be hard to visualize.
- For arXiv HTML, extract `img src` paths and download only useful figures into `raw/papers/images/`.
- For local HTML, resolve relative `img src` paths from the HTML file's directory, then copy useful figures into `raw/papers/images/`.
- Name images deterministically with a paper slug, for example `elf_x3.png` or `method_pipeline.png`.
- Verify every downloaded image with `file` or equivalent; if a saved “image” is HTML, fix the URL and redownload.
- Link images with relative Markdown paths from the paper note, for example `![ELF の訓練と生成パイプライン](images/elf_x3.png)`.

### 4. Write the Markdown Note

Update the existing paper stub in place, even when it is nested under `raw/papers/`, unless the user asks for a new file. Use this structure by default:

```markdown
# Paper Title

- 情報源: <HTML URL> ／ <abs/PDF URL>
- 著者: ...
- 日付: ...
- 主題: ...

---

## 要旨
## 何が新しいのか
## 背景: なぜ難しいのか
## 提案手法の全体像
## 中核数式の意味
## 実験設定
## 実験結果
## ablation で分かったこと
## 直感的な理解
## この論文の読みどころ
## 限界と注意点
## まとめ
```

Adapt headings to the paper, but keep the progression: overview -> motivation -> method -> math intuition -> evidence -> critique.

## Writing Style

- Write in Japanese.
- Explain what the paper claims, why the problem matters, how the method works, and what evidence supports it.
- Include concrete numeric results in tables when the paper reports them.
- Explain equations with nearby plain-language intuition.
- Compare against prior work when the paper positions itself that way.
- Separate observed facts from interpretation. Use phrases like `論文では...` for paper claims and `読み方としては...` for interpretation.
- Include limitations and evaluation caveats even if the paper has no explicit limitations section.

## Obsidian Compatibility

- Use `$...$` for inline math and `$$...$$` blocks on their own lines with blank lines around them.
- Avoid LaTeX macros that commonly fail in Obsidian MathJax. Replace `\bm{...}` with `\boldsymbol{...}`.
- Keep standard Markdown tables simple; avoid raw HTML.
- Keep image paths relative to the note location. If images are stored in `raw/papers/images/` and the note is `raw/papers/inbox/foo.md`, link as `../images/<name>.png`, not `images/<name>.png`.
- If the user wants full Obsidian-native formatting, use the `obsidian-formatter` skill after drafting.

## Final Verification

Before final response, use the checklist in `references/checklist.md`.
