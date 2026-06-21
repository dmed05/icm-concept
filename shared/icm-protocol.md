# ICM Protocol Reference

This file is a working summary of the Interpretable Context Methodology (ICM). The source paper is `Interpretable Context Methodology_ Folder Structure as Agent Architecture.pdf`.

## Purpose

ICM uses filesystem structure to orchestrate sequential, repeatable AI workflows with human review between stages. Numbered folders encode execution order, Markdown files define behavior, and readable files carry state between stages.

## Context layers

1. **Identity:** root `AGENTS.md` explains the workspace and how to enter it.
2. **Routing:** root `CONTEXT.md` directs requests to the correct resource or stage.
3. **Stage contract:** each numbered stage has a `CONTEXT.md` declaring its inputs, process, outputs, and verification.
4. **Reference material:** stable constraints live in root `_config/`, root `shared/`, or a stage's local `references/`.
5. **Working artifacts:** run-specific inputs and outputs live in stage `output/` folders or other explicitly declared locations.

## Design rules

- Give each stage one transformation.
- Number executable stages in workflow order.
- Declare every file a stage may load.
- Build and report a context manifest for each stage run.
- Require approval before loading undeclared workspace files.
- Keep stable rules separate from run-specific artifacts.
- Write each stage's result to its own `output/` directory.
- Stop for human review at stage boundaries.
- Use deterministic scripts for mechanical work that does not require model judgment.
- Improve recurring behavior at its source: update contracts or reference material instead of repeatedly patching outputs.

## Context enforcement

The folder hierarchy provides an inspectable loading convention, not an operating-system security boundary. Each stage must treat its `Inputs` section as an allowlist, avoid workspace-wide searches, and report the files it read. Strong isolation requires a runner or sandbox that exposes only the stage contract and its declared files.

## Recommended layout

```text
workspace/
├── AGENTS.md
├── CONTEXT.md
├── setup/
├── stages/
│   ├── _template/
│   ├── 01_first-stage/
│   └── 02_second-stage/
├── _config/
└── shared/
```

## Appropriate use

ICM fits workflows that are sequential, reviewable, and repeated with changing inputs. It is not intended to replace orchestration infrastructure for high concurrency, real-time multi-agent coordination, or complex automated branching.
