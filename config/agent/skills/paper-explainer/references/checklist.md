# Paper Explanation Completion Checklist

Use this checklist before saying the paper explanation is complete.

## Source Coverage

- The target paper was identified from the user request or `raw/papers`.
- The full paper source was read, not only the abstract.
- The note includes source URLs and version/date when available.
- Method, equations, experiments, ablations, and limitations were inspected when present.

## Markdown Deliverable

- The output file is in the expected path, usually `raw/papers/<paper>.md`.
- The note has a clear title and metadata.
- The note includes a detailed Japanese explanation, not only bullet summaries.
- The note explains the problem, novelty, method, equation intuition, evidence, and caveats.
- Numeric results are preserved in tables when useful.

## Figures

- At least one useful figure is included when the paper has visual concepts, pipelines, curves, or qualitative examples that help understanding.
- Figure files exist under `raw/papers/images/` or another appropriate relative path.
- `file` or equivalent confirms downloaded figure files are real images, not HTML error pages.
- Image links in Markdown are relative and resolve from the note location.

## Obsidian / MathJax

- Inline math uses `$...$`; display math uses standalone `$$` blocks.
- No `\bm` remains; use `\boldsymbol`.
- Avoid unsupported or package-specific macros unless verified.
- Markdown tables have valid separator rows.
- Raw HTML is absent unless there is a specific reason to keep it.

## Final Response

- Mention the created or updated file path.
- Mention image assets if added.
- Mention verification performed.
- If anything could not be verified or fetched, state that explicitly.
