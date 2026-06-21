# New Project Questionnaire

Use these answers to design a new ICM project workspace. The generated project will be saved separately; this builder remains reusable.

## Project identity

1. What should the project be called?
2. Where should its new workspace be created?
3. In one sentence, what is the project's purpose?

## Goal

1. What repeatable outcome should this workspace produce?
2. Who will use and review its outputs?
3. What marks a successful final result?

## Inputs

1. What source material begins each run?
2. Which input formats must be supported?
3. What information is stable across runs and belongs in root-level `_config/` or `shared/`?

## Workflow

1. What distinct transformations turn the input into the final result?
2. Where should a human review or edit an intermediate artifact?
3. Which steps are mechanical enough for a script instead of an agent?

## Outputs

1. What artifact should each stage produce?
2. What final format and destination are required?
3. What checks should run before each handoff?

## Constraints

1. What style, policy, domain, privacy, or compliance rules apply?
2. Which tools or external services may the agent use?
3. What must the agent never do without approval?

## Automation

1. How will a user start a new run?
2. Which stages may run automatically, and where is human approval mandatory?
3. Should outputs be replaced, versioned by run, or archived?
