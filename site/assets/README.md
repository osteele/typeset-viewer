# Landing-page images

Screenshots referenced by `../index.html`, all captured from a real document (a
short Typst paper with numbered headings, a figure, a table, mathematics, and a
bibliography) open in Typeset Viewer. Captured at 2x with
`screencapture -l <windowid> -o` and cropped.

One full-window shot carries the hero. Everything else is a small crop of a
single control or panel, set in the right margin beside the sentence it
illustrates.

| File | Class | Placement | Shows |
| --- | --- | --- | --- |
| `screenshot-main.png` | — | hero | Full window, table-of-contents sidebar |
| `crop-chart.png` | `.wide` | after the opening | Bar chart with its numbered caption |
| `crop-status.png` | `.mid` | Typst paragraph | Status bar: file, render duration, timestamp |
| `crop-status-sm.png` | — | ≤700px variant | Same, fewer words |
| `crop-switcher.png` | `.mfig` | sidebar paragraph | The five-segment sidebar mode control |
| `crop-thumbnail.png` | `.mfig` | sidebar paragraph | One page thumbnail with its heading label |
| `crop-toc.png` | `.mfig` | sidebar paragraph | Nested, numbered outline entries |
| `crop-figures.png` | `.mfig` | sidebar paragraph | Figure/table index entries with page numbers |
| `crop-reference.png` | `.mfig` | works-cited paragraph | One reference with lookup links and citation count |
| `crop-note.png` | `.mfig` | notes paragraph | A note card: quoted text plus comment |
| `crop-highlight-sm.png` | `.mid` | notes paragraph | The highlighted phrase in the rendered page |
| `crop-toolbar.png` | `.mid` | review-panel paragraph | The document toolbar buttons |

## Sizing

These are 2x captures, so an image's natural CSS width is its pixel width ÷ 2.
Aim to render between about 0.7x and 1.2x of that: below 0.7x the UI text goes
illegible, above ~1.3x it visibly softens.

- **`.mfig`** — the margin column, `12.5rem` (200px). Crops around 434px wide
  land at 1.09x. Keep new margin crops near 434px.
- **`.mid`** — inset in the text column, `30rem` (480px). Suits crops 730-1110px
  wide.
- **`.wide`** — `50rem` (800px), spanning text plus margin. It carries
  `clear: right` so it cannot slide under a margin float; that costs vertical
  space, so use it sparingly. Only `crop-chart` does.

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

## Still missing

Presentation mode, the review-panel suggestion cards, the reading-list window,
and Overleaf sync status.

To retake: the sidebars are only worth showing when the document has structure,
so use a source with headings, captions, and a bibliography.
