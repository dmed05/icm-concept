# Stage: Replace With Stage Name

## Job

State the single transformation this stage performs.

## Inputs

- Layer 4 (working): `replace-with-declared-input-path`
- Layer 3 (reference): `replace-with-declared-reference-path`

List every permitted input explicitly. Use `../../_config/`, `../../shared/`, or local `references/` paths for Layer 3 material. Avoid broad directory inputs when individual files can be named.

## Context audit

Before processing:

1. Build a context manifest containing only the files declared under **Inputs**.
2. Confirm that every manifest path exists and is readable.
3. Do not search, list, or read elsewhere in the workspace.
4. If an undeclared file is required, stop and request approval before reading it.

When reporting completion, list:

- root identity and routing files read;
- declared stage inputs read;
- any approved exceptions;
- declared inputs that were not read.

## Process

1. Read only the declared inputs.
2. Perform the stage's single transformation.
3. Write the declared artifact to `output/`.
4. Stop for human review.

## Outputs

- `output/replace-with-artifact.md`

## Verification

- Confirm the output exists and is readable.
- Confirm it satisfies this contract.
- Confirm factual claims and cross-stage dependencies as appropriate.
- Confirm that every file read appears in the context audit.
- Report uncertainties instead of silently inventing missing information.
