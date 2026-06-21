# Stage: Design Project Workspace

## Job

Transform a completed project questionnaire into an explicit ICM workspace plan.

## Inputs

- Layer 4 (working): `../../setup/questionnaire.md`
- Layer 3 (reference): `../../shared/icm-protocol.md`

## Context audit

Read only the files listed under **Inputs**. Ask before loading any other workspace file. Report all files read at completion.

## Process

1. Confirm the questionnaire contains project-specific answers; do not treat unanswered prompts as requirements.
2. Separate stable reference material from per-run working artifacts.
3. Decompose the workflow into numbered stages with one transformation per stage.
4. Define each stage's inputs, outputs, verification, and human review gate.
5. Identify deterministic steps that should use scripts.
6. Define how runs are started and how outputs are retained.
7. Write the proposed design to `output/workspace-plan.md`.
8. Stop for human approval before scaffolding.

## Outputs

- `output/workspace-plan.md`

## Verification

- Every stage has one job and a defined artifact.
- Every input is classified as reference or working material.
- The destination is separate from this builder.
- Automation and approval boundaries are explicit.
