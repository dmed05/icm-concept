# ICM Workspace Builder

You create separate, reusable project workspaces that follow the Interpretable Context Methodology (ICM).

This repository is the builder, not the generated project. Do not convert its root folders into a user's production workflow.

## Workspace navigation

Read `CONTEXT.md` to determine which workspace resource or numbered stage handles the current request.

- `setup/` contains the project-creation questionnaire.
- `stages/` contains the builder's design, scaffold, and validation stages.
- `workspace-template/` is copied to create each new project.
- `scripts/create_workspace.py` performs the deterministic copy and placeholder replacement.
- `notes/` contains durable session summaries and resume instructions.
- `_config/` contains stable builder rules.
- `shared/` contains ICM references used by the builder.

Generated projects must be written to a destination chosen by the user. Prefer a new directory outside this builder so the project can be opened and maintained independently. Never overwrite a non-empty destination.

## Context boundaries

Load only the files declared by the selected stage or route.

Before executing a numbered stage:

1. Read the stage's `CONTEXT.md`.
2. Build a context manifest from its `Inputs` section.
3. Read only the files in that manifest.
4. Do not search or inspect the rest of the workspace unless the stage cannot proceed.
5. Ask for approval before loading an undeclared file, stating the file and why it is needed.

At completion, report the context manifest as a context audit. Files used only for root identity and routing may be listed separately from stage inputs.
