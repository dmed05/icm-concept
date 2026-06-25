# ICM Workspace Builder

This repository is a builder for creating reusable project workspaces that follow the Interpretable Context Methodology (ICM). It is not the generated project itself.

Use this workspace when you want to collect requirements, design a repeatable workflow, scaffold that workflow into a separate directory, and validate the generated workspace before using it.

## What This Workspace Does

The builder follows a staged process:

1. Collect project requirements.
2. Design the project workspace plan.
3. Scaffold a new workspace from the template.
4. Validate the generated workspace.
5. Hand off work to the generated project directory.

Generated projects should be created in a user-chosen destination, preferably outside this repository. Do not convert the root folders of this builder into a production workflow.

## Directory Guide

| Path | Purpose |
|---|---|
| `CONTEXT.md` | Root routing map for deciding which resource or stage to use. |
| `LEARNING_LOG.md` | Public-safe record of development milestones and engineering decisions. |
| `setup/` | Project-creation questionnaire and intake material. |
| `stages/` | Numbered builder stages for design, scaffold, and validation. |
| `workspace-template/` | Clean source copied into each generated project. |
| `scripts/` | Deterministic workspace creation utilities. |
| `_config/` | Stable builder rules and conventions. |
| `shared/` | ICM reference material used by the builder. |
| `notes/` | Durable session summaries, status, decisions, and resume instructions. |

## Standard Workflow

### 1. Start With the Questionnaire

Begin with:

```text
setup/questionnaire.md
```

Use it to collect the user's project goals, workflow needs, expected artifacts, validation requirements, and operating constraints.

### 2. Design the Workspace

Run the design stage:

```text
stages/01_design/
```

This stage turns questionnaire answers into an approved workspace plan. Before running a numbered stage, read that stage's `CONTEXT.md` and load only the files declared in its `Inputs` section.

### 3. Scaffold the Generated Project

After the workspace plan is approved, run:

```text
stages/02_scaffold/
```

Provide a project name and destination directory. The generated project should be written to a separate, empty destination. Never overwrite a non-empty destination.

The deterministic creation utility is:

```text
scripts/create_workspace.py
```

### 4. Validate the Generated Project

After generation, run:

```text
stages/03_validate/
```

This stage inspects the generated workspace, reports validation results, and prepares the handoff.

### 5. Work in the Generated Project

Once validation is complete, open the generated project directory and follow that project's own:

```text
AGENTS.md
CONTEXT.md
```

From that point forward, the generated project is the active workspace. This builder remains the source for creating or updating workspace structures.

## Maintaining the Learning Log

Use `LEARNING_LOG.md` to record concise, public-safe development milestones. Good entries explain what changed, why it matters, and what safety or validation decision was made.

Do not put raw customer data, source exports, credentials, private file paths, or sensitive business details in the learning log. Summarize the engineering work instead.

The template includes its own `LEARNING_LOG.md`, so newly generated workspaces inherit this habit automatically.

## Resuming Work

To resume builder work from an earlier session, read the newest dated file in:

```text
notes/
```

To resume work in an existing generated project, open that generated project directly and follow its local instructions.

## Asking About ICM

For questions about ICM itself, use:

```text
shared/icm-protocol.md
```

Consult the source PDF only when the shared protocol file does not provide enough detail.

## Context Discipline

This repository is designed around explicit context boundaries.

Before executing any numbered stage:

1. Read the stage's `CONTEXT.md`.
2. Build a context manifest from its `Inputs` section.
3. Read only the files in that manifest.
4. Do not inspect unrelated workspace files unless the stage cannot proceed.
5. Ask for approval before loading an undeclared file, stating the file and why it is needed.

At completion, report the context manifest as a context audit. Files used only for root identity and routing should be listed separately from stage inputs.
