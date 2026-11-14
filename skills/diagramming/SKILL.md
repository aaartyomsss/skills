---
name: diagramming
description: Use when the user asks for a flowchart, user flow, process diagram, sequence diagram, state diagram, or "draw/visualise how X works", or when another skill needs a diagram in an HTML report or a Mermaid block for a README, PR or doc.
---

# Diagramming

A diagram answers one question for one audience. Mermaid text is the source of truth: it is editable, diffable, and the same text works in HTML, GitHub markdown and PRs. Hand-drawn SVG only for what Mermaid can't express (see [EDITORIAL.md](EDITORIAL.md)).

## Recipe

1. **Question + audience.** One line: "What happens when a user resets their password?" for PMs, or "Which modules does an order touch?" for engineers. This becomes the subtitle. Two questions → two diagrams.
2. **Kind.**
   - **User flow**: screens, user actions, decisions, outcomes. Read from the user's side; no tables, endpoints or class names.
   - **Technical flow**: modules, calls, data, queues, external systems. Ground every node in the code: read the real entry point and trace it; name nodes after real modules/functions. Never invent a step you didn't see. Unknown → label it `?` and say so.
3. **Diagram type.** `flowchart TD` for branching processes (default). `flowchart LR` for pipelines. `sequenceDiagram` when *who talks to whom, in what order* is the point. `stateDiagram-v2` for lifecycles (order status, auth session).
4. **Format.**
   - **HTML** (default; one file, Mermaid from CDN): copy [template.html](template.html), fill the placeholders, one `<figure>` per diagram; `.pair` grid for before/after. Write to `${TMPDIR:-/tmp}/<slug>.html` unless the user wants it in the repo (then `docs/diagrams/`).
   - **Mermaid only** when the target is markdown (README, PR body, docs) or the user asks: a ```` ```mermaid ```` block, or a `.mmd` file. GitHub and Notion render it natively.
   - **Image** when the target can't render Mermaid (Confluence, Slides, email): `bash <skill-dir>/scripts/check.sh <file> out.svg` exports each diagram as a standalone SVG (`out-1.svg`, `out-2.svg`, ... when there are several).
5. **Verify.** `bash <skill-dir>/scripts/check.sh <file.html|.md|.mmd>` (needs local Chrome/Chromium and network for the Mermaid CDN). It fails on Mermaid syntax errors and writes a PNG next to the file. Read the PNG and fix crossings, cramped labels, unreadable size. On a bare "syntax error", check the pitfalls below first, then bisect by commenting out edges. Not verified = not done.
6. **Deliver.** `xdg-open <file>` (macOS: `open`), give the absolute path.

## Conventions (keep the legend in the template in sync)

| Element | Mermaid | Class |
|---|---|---|
| Start / end | `id([Label])` | `happy` |
| Screen, step, module | `id[Label]` | `happy` on the main path, unstyled otherwise |
| Decision | `id{Question?}` | `decision`; edges labelled `\|yes\|` / `\|no\|` |
| Error, blocked, dead end | `id[Label]` | `error` |
| External system (email, Stripe, DB) | `id[(Label)]` for stores, `id[Label]` otherwise | `ext` |
| Async, retry, optional | `-.label.->` | |

- Happy path runs straight down the spine; errors branch to the side.
- Labels ≤ 6 words. Detail goes in a note below the figure, not in the node.
- More than ~15 nodes → split by `subgraph` or into several figures.

## Mermaid pitfalls (the usual render failures)

- Quote labels containing `( ) [ ] { } : ; # " /` → `id["Save (draft)"]`; use `#quot;` for an inner quote.
- Reserved words are never node ids: `end`, `click`, `style`, `class`, `classDef`, `subgraph`, `graph`, `flowchart`. A bare `end` label also breaks; `End` / `done` are fine.
- Node ids: letters, digits, `_` only. Reuse the same id to point back at a node; a new id makes a duplicate box.
- `classDef`/`class` are per diagram: repeat them in every `<pre class="mermaid">`.
- In HTML, escape `<` and `>` inside labels as `&lt;` `&gt;`.

## Common mistakes

- Diagramming the whole system instead of the asked question.
- Technical flow drawn from memory or naming conventions, not from reading the code.
- One giant diagram where three focused ones would read faster.
- Skipping step 5 because "Mermaid syntax looked fine".
