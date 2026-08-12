# Typeset Viewer — public site, releases, and issue tracker.
# The landing page (site/) deploys to typeset.osteele.com via Cloudflare Pages.

project := "typeset-preview"

default:
    @just --list

# Serve the landing page locally.
dev:
    wrangler pages dev site

# Deploy the landing page + appcast.xml to typeset.osteele.com.
deploy:
    wrangler pages deploy site --project-name {{project}} --branch main

# Stage the signed appcast produced by the app repo's `just appcast` into site/.
# Typical source: ~/code/document-tools/typeset-viewer/dist/appcast.xml
appcast source:
    cp "{{source}}" site/appcast.xml
    @echo 'Staged site/appcast.xml. Run just deploy to publish.'

# Open a fresh copy of the screenshot fixture with optional agent-review
# integration disabled for this process.
screenshots-launch app:
    bash screenshots/capture.sh launch "{{app}}"

# Capture one manifest asset from the frontmost Typeset Viewer document window.
screenshot id:
    bash screenshots/capture.sh capture "{{id}}"

# Verify that site image references, manifest entries, files, and dimensions agree.
screenshots-check:
    bun run check

check: screenshots-check
