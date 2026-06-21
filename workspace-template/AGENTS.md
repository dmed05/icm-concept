# {{PROJECT_NAME}}

This is an ICM project workspace. Read `CONTEXT.md` to route each request to the correct numbered stage.

## Context boundaries

For a numbered stage, treat its `Inputs` section as an allowlist:

1. Build a context manifest from the declared inputs.
2. Read only those files.
3. Ask before loading undeclared workspace files.
4. Report the context manifest when the stage completes.

Stop for human review at every stage boundary unless the stage contract explicitly permits automatic continuation.
