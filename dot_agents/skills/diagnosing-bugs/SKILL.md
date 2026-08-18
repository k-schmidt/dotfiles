---
name: diagnosing-bugs
description: Diagnose difficult bugs and performance regressions through a tight reproduction loop and falsifiable hypotheses. Use when the user asks to diagnose, debug, reproduce, or explain broken, failing, flaky, or slow behavior. A diagnosis-only request stops at the root cause; implement a fix only when requested.
---

# Diagnosing Bugs

Find the cause from observable evidence. Preserve the user's authorization boundary: diagnosis does not imply permission to edit code.

## Establish a tight signal

Read applicable project guidance, domain vocabulary, and relevant decisions. Before forming a theory, create one repeatable command or procedure that exercises the reported path and detects the user's exact symptom.

Prefer the narrowest faithful signal: a focused test, CLI invocation, HTTP request, browser check, captured-event replay, minimal harness, profiler measurement, or old-versus-new comparison. For intermittent failures, raise and record the reproduction rate rather than pretending the signal is deterministic.

The signal is ready when it is:

- **Faithful:** it distinguishes this bug from nearby failures.
- **Repeatable:** repeated runs give a stable verdict or a measured failure rate.
- **Tight:** setup and execution are narrow enough to run throughout diagnosis.
- **Agent-runnable:** it does not silently depend on unrecorded human actions.

Redact secrets, credentials, tokens, personal data, and authenticated headers from commands, output, fixtures, and captured artifacts. Keep credentials in the environment. If a faithful signal requires access or an artifact the user has not supplied, report what was attempted and request the minimum missing input instead of guessing.

Keep signal discovery and minimization in the primary task. Only after the reproduction signal is faithful and repeatable may read-only subagents test independent hypotheses. Give each one a prediction, a bounded probe, and a required evidence report. The primary task owns hypothesis ranking, any instrumentation or edits, and the final diagnosis.

## Minimize and explain

Reduce the failing case one input, dependency, configuration value, or step at a time. Re-run the signal after each reduction and retain only conditions that affect the verdict.

Then write two to four ranked, falsifiable hypotheses. For each, state:

- the proposed cause;
- the observation it predicts;
- the smallest probe that could disprove it.

Share the ranking when user context could cheaply reorder it, but continue with the strongest evidence when the user is AFK. Test one variable at a time. Prefer debugger or profiler evidence, then narrowly placed instrumentation at boundaries that distinguish hypotheses. Give temporary instrumentation a unique searchable marker and remove it before completion.

For performance regressions, establish a measured baseline before changing anything. Compare profiles, query plans, traces, or timings against that baseline; logs alone are rarely a sufficient performance signal.

## Conclude or fix

A diagnosis is complete only when the explanation accounts for the original signal and names the evidence that ruled out plausible alternatives. Report the root cause, triggering conditions, impact, confidence, and reasonable fix options. Stop there when the request was diagnosis-only.

When a fix is authorized:

1. Turn the minimized reproduction into a failing regression test at the highest faithful public seam, when such a seam exists.
2. Apply the smallest fix that addresses the demonstrated cause.
3. Run the regression test and the original, unminimized signal.
4. Run proportionate surrounding verification.
5. Remove temporary instrumentation and throwaway artifacts, retaining only useful tests or documented fixtures.

If no faithful test seam exists, say so explicitly rather than adding a shallow test that cannot catch the real failure. Treat the missing seam as an architectural finding.
