# Sales Commission Workspace Plan

## Project identity

- **Name:** `example-workspace`
- **Destination:** `/path/to/generated-workspace`
- **Purpose:** Convert the source business invoice CSV exports into accurate, auditable commission-pay summaries grouped by owner, payment date, customer, and service.
- **Builder boundary:** The project is generated as an independent workspace. The `icm-concept` builder remains reusable and is not converted into the production workflow.

## Repeatable outcome

Each run accepts one invoice CSV export from the source business and produces one audited CSV summary for records satisfying:

```text
Status == "Paid"
start_date < Date Paid
Date Paid <= end_date       # only when an inclusive end date is supplied
```

The summary groups qualifying invoices by resolved owner, payment date, customer, and service. Entries within each owner section are sorted from latest payment date to oldest. It includes owner subtotals and a grand total.

The reviewer reviews and approves each completed report for payment. The project owner is the authority for owner assignments and changes to owner-assignment or commission rules.

### Current calculation boundary

No commission rate, tier, split, eligibility adjustment, or commission formula has been supplied. The initial workflow may report qualifying invoice totals by owner, but it must not label a calculated value as commission owed until the project owner approves machine-readable commission rules. Adding such rules is a controlled future change.

## Input classification

### Stable reference material

The generated workspace will store these under `_config/`:

- `business-rules.md`
  - Paid-status requirement.
  - Exclusive start-date and optional inclusive end-date semantics.
  - Owner-assignment priority.
  - Grouping and sort rules.
  - Approval authorities.
  - Prohibition against silently assigning unresolved records to the project owner.
- `required-columns.txt`
  - `Status`
  - `Date Paid`
  - `Name`
  - `Service Name`
  - `Total`
  - `Owner`
  - `Contact Owner`
- `owner-overrides.csv`
  - Approved customer/account-to-owner assignments.
  - Each rule records its basis, approver, approval date, effective date, and optional retirement date.
- `owner-roster.csv`
  - Familiar approved owner names and normalized forms.
- `report-schema.md`
  - Summary, exception, reconciliation, manifest, and approval fields.

No owner or commission rule may be inferred solely from a source export and promoted into `_config/`.

### Per-run working material

Each run has a unique directory under `runs/` containing:

- An immutable copy of the source CSV.
- A run manifest with source filename and checksum, run ID, processing time, exclusive start date, optional inclusive end date, requested output filename, and configuration checksums.
- Validation results.
- Qualifying source rows.
- Owner exception and resolution records.
- Draft summary reports.
- Reconciliation evidence.
- Final approval record and approved reports.

Customer, payroll, and invoice data remain local to the project unless the project owner explicitly authorizes sharing.

## Command-line interface

Primary invocation:

```text
python3 scripts/run_commission.py \
  --input /path/to/invoices.csv \
  --output /path/to/summary.csv \
  --start-date 2026-05-04 \
  [--end-date 2026-05-18]
```

Requirements:

- `--input`, `--output`, and `--start-date` are required.
- `--end-date` is optional and inclusive.
- Dates use ISO `YYYY-MM-DD` at the command boundary.
- The output path must be inside the project unless the project owner approves otherwise.
- A final approved output must never be overwritten.
- Existing draft outputs may be replaced only when clearly marked as drafts.
- The source file is copied and checksummed; it is never modified.
- Interactive prompts are out of scope.

The command orchestrates deterministic stages until a human gate is reached. A rerun resumes from durable run artifacts rather than changing source data.

## Proposed workspace stages

### Stage 01 — Register run

**Job:** Capture the source export and reporting boundaries as an immutable run.

**Inputs:**

- User-supplied invoice CSV.
- Required exclusive start date.
- Optional inclusive end date.
- Requested output path.

**Transformation:**

- Validate command arguments.
- Create a unique run ID.
- Refuse a non-project output path unless explicitly authorized.
- Refuse to overwrite an approved run.
- Copy the source CSV into the run directory without modifying it.
- Record SHA-256 checksums for the source and active configuration.

**Output:** `run-manifest.json` and immutable source copy.

**Verification:**

- Source and copied-source checksums match.
- `end_date`, when supplied, is later than `start_date`.
- Paths and overwrite rules are satisfied.

**Gate:** None for a new valid run. Changing dates after registration requires approval and a new run/version.

### Stage 02 — Validate export

**Job:** Establish whether the export is structurally processable.

**Inputs:**

- Stage 01 run manifest.
- Immutable source copy.
- `_config/required-columns.txt`.
- Parsing rules from `_config/business-rules.md`.

**Transformation:**

- Confirm all seven required columns exist exactly once.
- Validate CSV readability.
- Validate `Date Paid` values needed for candidate Paid rows.
- Parse `Total` with `Decimal`, never binary floating point.
- Record malformed, missing, or ambiguous values without editing source rows.

**Output:** `validation-report.json`.

**Verification:**

- Required-column result is explicit.
- Parsed and rejected row counts reconcile to source data rows.
- Every rejected row includes its source row number and reason.

**Gate:** Blocking validation errors stop processing. Correcting source data requires approval and a new source export or separately versioned source.

### Stage 03 — Select qualifying invoices

**Job:** Apply status and payment-period eligibility rules.

**Inputs:**

- Validated source.
- Run date boundaries.
- Paid-status and date rules.

**Transformation:**

- Include only exact normalized Paid statuses approved by configuration.
- Apply `start_date < Date Paid <= end_date` when an end date exists.
- Otherwise apply `start_date < Date Paid`.
- Preserve source row identity and required source values.

**Output:** `qualifying-invoices.csv` plus `selection-report.json`.

**Verification:**

- Included, excluded, and rejected counts reconcile to validated source rows.
- Earliest and latest included payment dates satisfy the boundaries.
- Sum of qualifying `Total` values is recorded using `Decimal`.

**Gate:** None when configured rules and registered dates are unchanged.

### Stage 04 — Detect owner exceptions

**Job:** Identify every ownership record that cannot safely proceed automatically.

**Inputs:**

- Qualifying invoices.
- `_config/owner-roster.csv`.
- `_config/owner-overrides.csv`.
- Owner priority and normalization rules.

**Transformation:**

- Compare `Owner` and `Contact Owner`.
- Apply only already-approved deterministic overrides.
- Flag blank, unfamiliar, conflicting, or apparently incorrect owners.
- Never silently fall back to the project owner.

**Output:** Draft `owner-exceptions.csv`.

**Exception fields:**

- Invoice identifier.
- Customer.
- Date paid.
- Total.
- Source Owner.
- Source Contact Owner.
- Exception reason.
- Proposed owner.
- Final resolution.
- Approver.
- Approval date.
- Source row number.
- Applied rule identifier, when applicable.

**Verification:**

- Every qualifying invoice is classified as automatically resolved or exceptional.
- Classification counts equal the qualifying invoice count.
- Every proposed owner cites an approved rule or is explicitly marked for human decision.

**Gate:** the project owner must resolve ambiguous or unfamiliar owners and approve fallback ownership or rule changes.

### Stage 05 — Resolve ownership

**Job:** Produce one approved owner assignment for every qualifying invoice.

**Inputs:**

- Qualifying invoices.
- Owner exception report completed through human review.
- Current approved owner rules.

**Transformation:**

- Apply approved exception resolutions.
- Record the rule or signed resolution supporting each assignment.
- Separate one-run resolutions from proposed durable rule changes.
- Do not update stable configuration without the project owner's explicit approval.

**Output:** `resolved-invoices.csv` and `owner-resolution-audit.csv`.

**Verification:**

- Every qualifying invoice has exactly one resolved owner.
- No unresolved, blank, or unfamiliar owner remains.
- Counts and totals match Stage 03.
- Every changed owner has an audit trail.

**Gate:** Unresolved assignments block all final summary generation. the project owner approves durable owner-rule changes.

### Stage 06 — Generate summaries

**Job:** Convert resolved invoices into grouped payment-review reports.

**Inputs:**

- Resolved invoices.
- Grouping, sorting, naming, and output schema rules.

**Transformation:**

- Group by resolved owner, payment date, customer (`Name`), and service (`Service Name`).
- Sort each owner's entries by payment date from latest to oldest.
- Calculate grouped totals and owner subtotals with `Decimal`.
- Calculate the grand total.
- Produce the full summary and owner-specific reports.

**Outputs:**

- Draft full summary CSV.
- Draft owner-specific CSV files.
- Machine-readable summary metadata.

**Verification:**

- Each resolved invoice contributes exactly once.
- Group totals equal their underlying invoice totals.
- Owner subtotals equal their group totals.
- Grand total equals all owner subtotals.

**Gate:** Outputs remain drafts pending reconciliation and Reviewer approval.

### Stage 07 — Reconcile run

**Job:** Prove the generated summaries match the qualifying source population.

**Inputs:**

- Stage 03 qualifying invoices.
- Stage 05 resolved invoices.
- Stage 06 draft summaries.
- Prior stage count and total reports.

**Transformation:**

- Compare invoice counts and unique source-row identities.
- Compare qualifying, resolved, grouped, owner-subtotal, and grand-total amounts.
- Detect dropped, duplicated, or altered rows.
- Record all checks and exact differences.

**Output:** `reconciliation-report.json` and a concise review CSV.

**Verification:**

- Qualifying count equals resolved count.
- Every qualifying source row appears exactly once in resolved input and summary lineage.
- All monetary comparisons match exactly at the configured currency precision.
- Any discrepancy blocks approval.

**Gate:** The reviewer reviews the exception audit, summaries, and reconciliation evidence.

### Stage 08 — Approve and archive

**Job:** Record payment approval and preserve a non-overwritable final run.

**Inputs:**

- Reconciled draft reports.
- Completed owner-resolution audit.
- Reviewer's approval decision.

**Transformation:**

- Record reviewer, approval timestamp, reporting boundaries, source checksum, configuration checksums, invoice count, owner subtotals, and grand total.
- Promote drafts to unique final filenames.
- Mark the run immutable/approved in its manifest.

**Outputs:**

- Final full-summary CSV.
- Final owner-specific CSV files.
- Final exception CSV.
- `approval-record.json`.
- Archived run evidence.

**Verification:**

- No reconciliation check failed.
- No owner exception is unresolved.
- Final report checksums are recorded.
- Final filenames do not already exist.
- Approval identity is Reviewer.

**Gate:** Reviewer alone declares a completed report ready for payment. Any later correction creates a new version linked to the superseded run.

## Output naming

Existing examples remain recognizable:

- `Invoices_Paid_After_05.04.csv`
- `Owner_Name_Paid_After_05.04.csv`
- `Owner_Exceptions_After_05.04.csv`

For auditability and collision avoidance, the generated workspace should default to ISO dates and explicit boundaries:

```text
Invoices_Paid_2026-05-05_to_2026-05-18_<run-id>.csv
Owner_Name_Paid_2026-05-05_to_2026-05-18_<run-id>.csv
Owner_Exceptions_2026-05-05_to_2026-05-18_<run-id>.csv
```

For an open-ended run:

```text
Invoices_Paid_After_2026-05-04_through_<latest-date>_<run-id>.csv
```

The CLI's requested `--output` is honored for a draft when safe. Final approved filenames always include unique run identity or version information and are never overwritten.

## Deterministic implementation

Use version-controlled Python with the standard library:

- `csv` for CSV input and output.
- `decimal.Decimal` for currency.
- `datetime` for dates.
- `hashlib` for checksums.
- `json` for manifests and reconciliation evidence.
- `argparse` for the command-line interface.
- `unittest` for automated tests.

No additional Python libraries, cloud services, or external data processors may handle unsanitized data without approval. Spreadsheet software is for human review only.

Suggested scripts:

- `scripts/run_commission.py` — CLI and stage orchestration.
- `scripts/validate_export.py` — schema and format checks.
- `scripts/select_invoices.py` — status and date filtering.
- `scripts/resolve_owners.py` — exception detection and approved-rule application.
- `scripts/generate_reports.py` — grouping, sorting, and totals.
- `scripts/reconcile.py` — independent count, lineage, and amount checks.

Shared library code should centralize CSV parsing, date parsing, money handling, checksums, and run-manifest updates so stage scripts do not implement conflicting rules.

## Test requirements

Automated tests must cover:

- Missing or duplicate required columns.
- Empty files and malformed CSV.
- Paid versus non-Paid statuses.
- Exact exclusion of the start date.
- Exact inclusion of the end date.
- Open-ended periods.
- Invalid and blank `Date Paid`.
- Currency parsing, rounding policy, commas, negatives, and blank totals.
- Blank owners.
- Matching and conflicting Owner/Contact Owner values.
- Unfamiliar owners.
- Approved customer overrides.
- Prohibition against defaulting unresolved records to the project owner.
- Duplicate invoice identifiers and duplicate source rows.
- Grouping and latest-to-oldest sorting.
- Owner subtotals and grand-total reconciliation.
- Final-output overwrite refusal.
- Source checksum preservation.
- Sanitized end-to-end fixture with representative exception cases.

Currency precision and rounding behavior must be approved and documented before implementation if source totals contain more than two decimal places or multiple currencies.

## Approval and safety boundaries

Approval is always required for:

- Changing owner-assignment or commission rules.
- Resolving ambiguous or unfamiliar owners.
- Accepting fallback ownership for blank records.
- Changing cutoff or period boundaries after processing.
- Modifying source data.
- Sharing data outside the project.
- Adding third-party libraries or cloud tools for unsanitized data.
- Declaring a final report ready for payment.

Routine local validation, filtering, exception detection, application of existing approved rules, grouping, reconciliation, and draft generation may run automatically.

## Retention and access gaps

The project currently has no approved retention period, deletion procedure, encryption requirement, or named access-control policy. The workspace must therefore:

- Avoid automated deletion.
- Avoid external synchronization or sharing.
- Keep data local to the project.
- Document these as unresolved governance decisions rather than inventing policy.

## Scaffold acceptance criteria

Before the workspace is considered ready:

- Every numbered stage has a `CONTEXT.md` declaring only its allowed inputs.
- Stable rules are separate from per-run artifacts.
- The source export is copied and checksummed but never modified.
- Owner exceptions block final generation until resolved.
- Summary generation and reconciliation use independent checks where practical.
- Tests pass using sanitized fixtures.
- The CLI enforces date semantics and overwrite protections.
- The project destination is separate from the builder and is empty before creation.
- No unapproved commission formula is present.

## Human decision required

Approve this workspace plan before Stage 02 scaffolding.

Approval should also confirm that the initial report represents qualifying invoice totals by owner, not a calculated commission payable amount, until commission calculation rules are separately provided and approved.
