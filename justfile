# Typeset Preview — public site, releases, and issue tracker.
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
# Typical source: ~/code/apps/typeset-viewer/dist/appcast.xml
appcast source:
    cp "{{source}}" site/appcast.xml
    @echo "Staged site/appcast.xml. Run `just deploy` to publish."
