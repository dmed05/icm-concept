# Workspace Context

## Purpose

`icm-concept` is an ICM workspace-builder. It collects requirements, designs a repeatable workflow, creates that workflow in a separate directory, and validates the generated workspace.

## Routing

- To create a new project, begin with `setup/questionnaire.md`, then run `stages/01_design/`.
- After approving the workspace plan, run `stages/02_scaffold/` with a project name and destination.
- After generation, run `stages/03_validate/`.
- To resume an existing generated project, open that project's directory and follow its own `AGENTS.md` and `CONTEXT.md`.
- To resume builder work from an earlier session, read the newest dated file in `notes/`.
- To answer questions about ICM itself, use `shared/icm-protocol.md` and consult the source PDF only when more detail is required.

## Shared resources

- `_config/`: stable builder constraints and conventions
- `shared/`: ICM reference material
- `setup/`: project-creation intake
- `stages/`: the builder's numbered stages
- `workspace-template/`: clean source copied into each generated project
- `scripts/`: deterministic workspace creation utilities
- `notes/`: dated decisions, status, and next actions

## Stage map

| Stage | Handles | Produces | Next |
|---|---|---|---|
| `01_design` | Questionnaire answers and workflow decomposition | Approved workspace plan | `02_scaffold` |
| `02_scaffold` | Project name, destination, and approved plan | Separate generated workspace | `03_validate` |
| `03_validate` | Generated workspace inspection | Validation report and handoff | Open the generated project |
