# Pull Request Format Reference

## Title

Use:

```text
<type>: <short description>
```

Pick the type from the same categories used in Conventional Commits.

## Body

Use this structure:

```markdown
## Summary
- <3 items or fewer>

## Changes
- <main implementation changes>

## Test plan
- <tests run or checks to run>

## Additional notes
- <optional follow-ups, rollout notes, or caveats>
```

## Writing Rules

- `Summary` should stay short and reviewer-oriented.
- `Changes` should mention the most important implementation areas, not every file.
- `Test plan` must reflect real verification status.
- `Additional notes` is optional; omit empty filler.

## Draft Criteria

Use Draft PR when:

- key implementation is intentionally incomplete
- validation is still pending
- external dependency or reviewer input is blocking completion

## Label Rule

Ensure the PR uses the `claude` label. If the label is missing, create it before the PR is opened.

