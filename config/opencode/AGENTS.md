Working code is not automatically clean code.

## Always

- Preserve behavior. Leave touched code cleaner within the request's scope; no drive-by refactors.
- Prefer precise names, small focused functions, and explicit mutation over cleverness.
- Keep the happy path readable; isolate error and edge handling.
- No secrets in code, logs, or commits. Run relevant lint/typecheck/tests before calling work done.
- Do not broaden the task beyond the smallest change that makes the request safe and readable.

## On demand

- Substantial edits or refactors: load the `clean-code` skill.
- Architecture or dependency-boundary work: load the `clean-architecture` skill.
- Pure structure/readability improvements with no behavior change: load the `refactoring` skill.
- Project-local build, test, and layout rules live in the project's own `AGENTS.md` when present.
