# blockr.uat

A blockr board deployed to Posit Connect for user acceptance testing, published via blockr.ci's pull-mode `connect-deploy` pipeline.

## Contents

- `app.R` — a blockr dock board launched through `blockr::run_app()`, with the DAG, assistant and markdown document extensions enabled and board persistence wired up via blockr.session's `manage_project()`. `run_app()` returns the `shinyApp` object Connect runs.
- `DESCRIPTION` — declares runtime dependencies (`Imports:`) and pins every blockr.* package to its GitHub main branch (`Remotes:`) so the deploy workflow resolves the development versions from the package metadata rather than stale CRAN/release builds.
- `.github/workflows/connect-deploy.yaml` — calls the reusable `connect-deploy` workflow in `cynkra/blockr.ci`.

## How deployment works

Connect sits on an internal network a GitHub runner cannot reach, so deployment is pull-mode. On merge to a source branch (`main`), the `connect-deploy` workflow regenerates `manifest.json` from inside the merge queue and force-pushes it to a derived `connect-<base>` branch (`connect-main`) that Connect polls. Source branches stay manifest-free; only the `connect-*` branches carry the manifest.

The reusable workflow, the GitHub App / branch ruleset / protected environment it needs, and the one-time bootstrap are documented in [blockr.ci's Connect deployment setup](https://github.com/cynkra/blockr.ci#connect-deployment-setup).
