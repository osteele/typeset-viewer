# Typeset Viewer

A native macOS preview and review tool for **Typst, Markdown, LaTeX, and PDF** files. Open a supported file and it renders to a PDF and displays it in a fast native window — with live refresh, notes, review tools, a reading list, and presentation mode.

**Website:** [typeset.osteele.com](https://typeset.osteele.com) · **Download:** [latest release](https://github.com/osteele/typeset-preview/releases/latest)

> This repository hosts the app's **releases, website, and issue tracker**. Typeset Viewer is free but closed-source; the application source is not included here.

<!-- Add a screenshot: ![Typeset Viewer](site/assets/screenshot-main.png) -->

## Install

1. Download the latest `.zip` from [Releases](https://github.com/osteele/typeset-preview/releases/latest).
2. Unzip and drag **Typeset Viewer** to your Applications folder.
3. Open it. The app is notarized by Apple, so it launches without security warnings.

**Requirements:** macOS 13 or later (Apple silicon). Typst is bundled. Markdown rendering uses [Pandoc](https://pandoc.org); LaTeX rendering uses `latexmk` (MacTeX/BasicTeX). The app reports clearly when an external tool is missing.

## Features

- **Renders Typst, Markdown, LaTeX, and PDF** — Typst via the bundled `typst`, Markdown via Pandoc, LaTeX via `latexmk`; PDFs open directly.
- **Live refresh** — edit the source in your own editor and the preview re-renders on save, preserving your reading position.
- **Notes & highlights** — annotate rendered text and export notes with context.
- **Document review** — readability, citation coverage, proofreading, and prose-tightening checks as reviewable suggestions.
- **Reading list** — collect papers by arXiv ID or URL; open, search, or export them.
- **Presentation mode** — page-fit slide navigation with an optional iPhone remote.

## Updates

Typeset Viewer updates itself using [Sparkle](https://sparkle-project.org). Use **Check for Updates…** in the app menu, or let it check on its own.

## Feedback & bug reports

- **Report a bug:** [open an issue](https://github.com/osteele/typeset-preview/issues/new?labels=bug), or use **Help ▸ Report a Bug…** in the app (it pre-fills your version and environment).
- **Email:** [steele@osteele.com](mailto:steele@osteele.com)

## License

Typeset Viewer is proprietary freeware. See [LICENSE](LICENSE). It bundles third-party tools under their own licenses, including Typst (Apache-2.0).
