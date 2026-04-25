# Conventional Commits Reference

Use the format:

```text
<type>: <description>
```

## Allowed Types

- `feat`: user-facing feature or capability
- `fix`: bug fix or behavioral correction
- `docs`: documentation-only change
- `style`: formatting or non-behavioral style cleanup
- `refactor`: structural code change without intended behavior change
- `perf`: performance improvement
- `test`: test addition or test correction
- `chore`: tooling, config, dependency, or maintenance work

## Message Rules

- Use imperative phrasing.
- Match the actual diff.
- Prefer one clear concern per commit.
- Avoid vague subjects like `update files` or `fix issues`.

## Split Heuristics

Split commits when the diff contains:

- unrelated concerns
- different change types, such as feature plus docs plus tooling
- changes that would be easier to review independently
- large edits that become clearer as separate history entries

## Examples

- `feat: add service account for cloud run`
- `fix: extend llm inference timeout`
- `docs: add notes for exp002 experiment`
- `refactor: simplify parser error handling`
- `chore: update development tool configuration`

