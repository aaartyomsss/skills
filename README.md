# skills

Personal Claude Code skills.

| Skill | Use |
|---|---|
| `grilling` | Interview rounds that stress-test a plan or idea |
| `/grill-me` | Slash shortcut for `grilling` |
| `/grill-with-docs` | `grilling` + `domain-modeling`: updates GLOSSARY.md and ADRs as decisions land |
| `domain-modeling` | Maintain GLOSSARY.md and ADRs |
| `codebase-design` | Deep-module vocabulary; design-it-twice |
| `/improve-codebase-architecture` | Find deepening opportunities, HTML report, then grill one |
| `diagramming` | Flowcharts (technical and user flows) as HTML or Mermaid |
| `documenting` | Feature docs, ADRs, runbooks into local markdown, Confluence or Notion; pairs with `diagramming` |

## Install

```bash
claude plugin marketplace add aaartyomsss/skills
claude plugin install skills@aaartyomsss
```

For local editing, symlink instead: `ln -s ~/skills/skills/* ~/.claude/skills/`

## Credit

All skills except `diagramming` and `documenting` are adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT). `diagramming` extracts and extends the diagram patterns from its `improve-codebase-architecture` report.
