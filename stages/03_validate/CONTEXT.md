# Stage: Validate Generated Workspace

## Job

Validate the generated workspace's structure, routing, contracts, and context boundaries.

## Inputs

- Layer 4 (working): `../02_scaffold/output/generation-report.md`
- Layer 4 (working): generated workspace path declared in the generation report
- Layer 3 (reference): `../../shared/icm-protocol.md`

## Context audit

Limit inspection to the generated workspace named in the generation report and the declared protocol reference. Report every file inspected.

## Process

1. Confirm all root routes resolve.
2. Confirm numbered stages match the approved workflow order.
3. Confirm each stage declares explicit inputs, outputs, verification, and context audit behavior.
4. Confirm Layer 3 references and Layer 4 artifacts are separated.
5. Confirm the generated project can be opened independently of this builder.
6. Write findings to `output/validation-report.md`.

## Outputs

- `output/validation-report.md`

## Verification

- Report failures with exact paths.
- Do not report success while unresolved placeholders or broken routes remain.
