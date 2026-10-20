Working code is not automatically clean code.

## Always

- Preserve behavior. Leave touched code cleaner within the request's scope; no drive-by refactors.
- Prefer precise names, small focused functions, and explicit mutation over cleverness.
- Keep the happy path readable; isolate error and edge handling.
- Do not broaden the task beyond the smallest change that makes the request safe and readable.
- No secrets in code, logs, or commits.