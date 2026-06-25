# Sales Commission Generation Report

## Result

- **Project:** `example-workspace`
- **Generated workspace:** `/path/to/generated-workspace`
- **Source:** builder `workspace-template/`
- **Approved design:** `stages/01_design/output/workspace-plan.md`
- **Status:** Scaffold generated; validation has not yet run.

## Populated structure

- Independent root `AGENTS.md` and `CONTEXT.md`.
- Project definition with the project owner and reviewer authority boundaries.
- Stable business rules, required headers, owner roster schema, owner override schema, and report schemas under `_config/`.
- Eight numbered stage contracts:
  1. Register run.
  2. Validate export.
  3. Select qualifying invoices.
  4. Detect owner exceptions.
  5. Resolve ownership.
  6. Generate summaries.
  7. Reconcile run.
  8. Approve and archive.
- Reserved local directories for input, immutable run evidence, deterministic scripts, tests, and shared references.

## Verification performed

- Destination was outside the builder and empty before generation.
- The template was copied using `scripts/create_workspace.py`.
- The template stage was replaced by exactly eight numbered stages.
- Generated root identity and routing files exist.
- No template placeholder tokens remain in generated files.
- The source builder's workflow directories were not repurposed as the generated project.

## Deliberate implementation boundary

This stage created the approved ICM structure and contracts. The deterministic Python processing code and tests are not implemented yet and must be addressed as project work before processing production data.

The generated workspace reports qualifying invoice totals only. It contains no invented commission formula and must not represent totals as commission owed.

## Next action

Run builder Stage 03 validation against `/path/to/generated-workspace`.
