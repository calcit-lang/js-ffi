# Ensure candidate CLI path precedence

The first candidate CI run compiled the requested core commit successfully, but later steps still resolved the released setup-calcit binary and failed with `Unrecognized argument: check-public`.

- Prepend Cargo's binary directory to `GITHUB_PATH` after installing the candidate.
- Invoke the candidate by absolute path immediately and require `analyze check-public --help` to succeed, so a future path regression fails at the installation boundary.
