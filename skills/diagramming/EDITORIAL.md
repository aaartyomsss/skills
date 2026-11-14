# Editorial patterns (hand-built HTML/SVG)

Use these when the point is *weight* or *shape* rather than wiring, which Mermaid can't render with the right emphasis. Mix with Mermaid figures; don't make every diagram look the same. Keep each ~320px tall so before/after pairs sit side by side.

- **Boxes-and-arrows, by hand**: `<div>`s with borders as boxes, inline SVG `<path>` arrows absolutely positioned over a `position:relative` container. For an "after" that should read as one thick-bordered box with greyed-out internals.
- **Cross-section** (layers a call passes through): stacked horizontal bands (`height:3rem; border-left:4px solid`). Before: six thin bands each doing nothing. After: one thick band labelled with the consolidated responsibility.
- **Mass diagram** (interface vs implementation size): two rectangles per thing, one for surface area, one for what's behind it. Before: nearly equal heights. After: short top, tall bottom.
- **Collapse**: before, a tree of nested boxes; after, the same tree collapsed into one box with the old pieces faded (`opacity:.35`) inside it.
- **Journey strip** (user flows across channels): a horizontal row of screen cards with the channel (web, email, mobile) as a small tag above each, arrows between. Good for flows that leave the app and come back, such as an email link.

Labels inside these: `font-size:.75rem; text-transform:uppercase; letter-spacing:.05em` so they read as schematic, not as UI. Colours from the template legend only. Run `scripts/check.sh` on these too: it can't catch layout bugs, so read the PNG.
