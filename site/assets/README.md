# Landing-page images

Screenshots referenced by `../index.html` use a synthetic Typst paper with
numbered headings, a figure, a table, mathematics, and a bibliography. The
original document captures predate the persisted fixture. New and replacement
captures use `../../fixtures/screenshots/adaptive-quadrature/`, which preserves
the same title and document structure. The original captures were taken at 2x
with `screencapture -l <windowid> -o` and cropped. The newer feature-row
captures are native-scale app and browser UI crops.

`../../screenshots/manifest.json` records every deployed PNG, its dimensions,
and the standalone-product launch profile. `just screenshots-launch APP PROFILE`
opens an isolated fixture copy with optional `agent-review` integration disabled
for that process. The profiles are `document`, `reading-list`, and `overleaf`.
`just screenshot ID` captures the current app window, and
`just screenshots-check` verifies the manifest against the page.

One full-window shot carries the hero. Small controls sit in the right margin;
larger feature captures alternate beside their text in two-column rows.

| File | Class | Placement | Shows |
| --- | --- | --- | --- |
| `screenshot-main.png` | — | hero | Full window, table-of-contents sidebar |
| `crop-chart.png` | `.wide` | after the opening | Bar chart with its numbered caption |
| `crop-status.png` | `.mid` | Typst paragraph | Status bar: file, render duration, timestamp |
| `crop-status-sm.png` | — | ≤700px variant | Same, fewer words |
| `crop-pdf-icon.png` | `.mfig.icon` | PDF export paragraph | Draggable PDF title-bar icon |
| `crop-reading-list.png` | `.feature-row` | reading-list row, left | Synthetic saved papers with provenance and actions |
| `crop-switcher.png` | `.mfig` | sidebar paragraph | The five-segment sidebar mode control |
| `crop-thumbnail.png` | `.mfig` | sidebar paragraph | One page thumbnail with its heading label |
| `crop-toc.png` | `.mfig` | sidebar paragraph | Nested, numbered outline entries |
| `crop-overleaf-status.png` | `.feature-row` | Overleaf row, right | Synced local checkout status |
| `crop-figures.png` | `.mfig` | sidebar paragraph | Figure/table index entries with page numbers |
| `crop-reference.png` | `.mfig` | works-cited paragraph | One reference with lookup links and citation count |
| `crop-note.png` | `.mfig` | notes paragraph | A note card: quoted text plus comment |
| `crop-highlight-sm.png` | `.mid` | notes paragraph | The highlighted phrase in the rendered page |
| `crop-review.png` | `.feature-row` | review row, left | One review card with original and proposed text |
| `crop-selection-minibar.png` | `.mid` | selection paragraph | Selected text with the adaptive action bar |
| `crop-quiz.png` | `.feature-row` | quiz row, right | Revealed answer, Agent handoff, and compact recall strip |
| `crop-presentation-remote.png` | `.feature-row` | presentation row, left | Responsive phone remote with slide preview |

## Sizing

For 2x captures, an image's natural CSS width is its pixel width ÷ 2. Aim to
render between about 0.7x and 1.2x of that: below 0.7x the UI text goes
illegible, above ~1.3x it visibly softens. The native-scale feature captures
render close to their pixel dimensions.

- **`.mfig`** — the margin column, `12.5rem` (200px). Crops around 434px wide
  land at 1.09x. Keep new margin crops near 434px.
- **`.mid`** — inset in the text column, `30rem` (480px). Suits crops 730-1110px
  wide.
- **`.wide`** — `50rem` (800px), spanning text plus margin. It carries
  `clear: right` so it cannot slide under a margin float; that costs vertical
  space, so use it sparingly. Only `crop-chart` does.
- **`.feature-row`** — `50rem` (800px), split between prose and a substantial
  UI capture. Rows alternate the visual between left and right. On narrow
  screens the text comes first and the screenshot follows it.

Below 900px the margin column collapses and both `.mfig` and `.sidenote` become
blocks in the text column. `.mfig` is capped at `15rem` there — stretching a
217px-natural crop to the full column would upscale it 1.6x.

## Wide, short strips

A one-line strip like `crop-status` (21:1) has to shrink about 4x to fit a
phone, which makes its text illegible. Rather than scaling the same image down,
it ships a **narrower crop** — fewer words at the same pixel scale — selected
with `<picture>` at `max-width: 700px`.

Size the narrow variant so its natural CSS width is near a phone's viewport,
around 370-440px. That renders it at roughly 1:1 on retina instead of a 0.4x
downscale. Crop so the part that carries the point is on the **left**, then cut
the narrow variant from that side.

`crop-highlight-sm.png` began as one of these pairs. The wide version was
dropped: at `.mid` the narrow crop reads well on both desktop and phone, and one
line of highlighted text says everything the wider one did. It is cropped to a
single line on purpose — a rectangle taken across two lines of justified text
slices the second one mid-word.

To retake: use the persisted fixture. The sidebars are only worth showing when
the document has structure, so keep its headings, captions, and bibliography.
