# Stage: Scaffold Project Workspace

## Job

Create the approved project as a separate ICM workspace and populate its project-specific contracts.

## Inputs

- Layer 4 (working): `../01_design/output/workspace-plan.md`
- Layer 3 (reference): `../../workspace-template/`
- Mechanical tool: `../../scripts/create_workspace.py`

## Context audit

The template directory is permitted because this stage copies it mechanically. Read project-specific template files only when required to populate the approved plan. Ask before reading other builder files.

## Process

1. Confirm the user-approved project name and destination.
2. Refuse to overwrite a non-empty destination.
3. Run `scripts/create_workspace.py PROJECT_NAME DESTINATION`.
4. Replace template stage folders with the numbered stages in the approved plan.
5. Populate root routing, project definition, references, and stage contracts.
6. Record the generated workspace's absolute path in `output/generation-report.md`.
7. Stop before validation.

## Outputs

- A separate project workspace at the approved destination
- `output/generation-report.md`

## Verification

- The builder's own root structure remains unchanged.
- The generated workspace has its own `AGENTS.md` and `CONTEXT.md`.
- No placeholder tokens remain in generated Markdown files.
