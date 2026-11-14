---
name: documenting
description: Use when the user wants to document a feature, decision (ADR), module, architecture, flow or how-to/runbook, or write or update a README, docs/ page, Confluence page or Notion page.
---

# Documenting

A doc answers what a specific reader needs to act, is grounded in the code, and lives where that reader looks.

## 1. Destination

The user decides where the doc goes. If they haven't said, ask once before writing, offering: a local markdown file (which one: a README section or `docs/<path>.md`; suggest whatever the repo already uses), Confluence (space and parent page), Notion (parent page), or another connected tool. Reading sources while you wait is fine; writing is not.

| Destination | Write with | Diagrams |
|---|---|---|
| Local markdown | Edit the file. Update the existing section in place; never append a near-duplicate. | ```` ```mermaid ```` block inline |
| Notion | Notion connector (MCP), markdown body | ```` ```mermaid ```` code block; Notion renders it |
| Confluence | Atlassian connector (MCP), markdown body | Confluence doesn't render Mermaid. Export SVG (diagramming skill); the user attaches it. Put the Mermaid source in a code block below the image so it stays editable. |
| Other (Google Docs, Claude Docs, ...) | That tool's connector | Image (SVG) unless it renders Mermaid |

If the connector only exposes `authenticate`, run it and let the user finish the login. No connector at all: write the markdown locally, give the path, and say what's missing. Don't improvise REST calls with tokens.

## 2. Shape by doc type

These sections are a menu. Drop any that would be empty or obvious.

- **Feature**: what it does, from the user's side (one paragraph) · how it works (diagram + the key modules with paths) · configuration and flags · edge cases and limits · how to verify · links (PRs, tickets).
- **ADR**: call the Skill tool with "domain-modeling" and use its ADR format. Locally: `docs/adr/NNNN-slug.md`. Externally: the same content, titled `ADR-NNNN: <decision>`.
- **Module / architecture**: purpose · interface (use the codebase-design vocabulary if the repo uses it) · diagram of collaborators · where to change what.
- **How-to / runbook**: prerequisites · numbered steps with exact commands · how to verify · rollback.

## 3. Gather facts

Read the code, PR, ticket or conversation that the doc describes. Every claim must trace to a source. A gap becomes a question to the user or a visible `TODO:`, never plausible filler. Links to code: relative paths in local markdown; in external tools, permalinks pinned to a commit (`<remote>/blob/<sha>/<path>`) so they don't rot.

## 4. Diagrams

Add one when the point is a flow, a sequence or a structure (three or more actors, or a branch). Call the Skill tool with "diagramming", verify with its `check.sh`, and embed according to the table above. One diagram per question.

## 5. Write

- Lead with what the reader needs. No "This document describes...".
- Use scannable headings, short paragraphs, and code identifiers in backticks.
- External docs drift: add a footer line `Last verified: <date> against <repo>@<short-sha>`.
- Glossary terms from `GLOSSARY.md`, if one exists.
- The repo's own writing rules (CLAUDE.md, AGENTS.md, CONTRIBUTING.md, a docs style guide) override this list.

## 6. Review, then publish

- **Local**: write the file and summarize what changed.
- **External**: write the draft to `${TMPDIR:-/tmp}/doc-<slug>.md`, give the path, and confirm the destination and title before creating or updating the page; publishing is visible to others. Search for an existing page with the same subject first. When updating, read the current page and change only what changed. Afterwards give the page URL and the paths of any SVGs to attach.

## Common mistakes

- Guessing the destination, or publishing without confirmation.
- Describing the code from memory or from file names instead of reading it.
- Restating the code line by line. Document intent, contracts and gotchas; the code shows the rest.
- A Mermaid block pasted into Confluence, where it shows up as raw text.
