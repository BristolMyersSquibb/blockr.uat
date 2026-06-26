# blockr.uat

A blockr board deployed to Posit Connect for user acceptance testing, published via blockr.ci's pull-mode `connect-deploy` pipeline.

This repository is itself a small R package: the app logic is an exported `run_app()`, so it gets the same blockr.ci CI (lint, `R CMD check`, coverage) as every other blockr.* package.

## Contents

- `R/run_app.R` — the exported `run_app()` that builds the blockr dock board (an `mtcars` dataset feeding a ggplot point block, with the DAG, assistant and markdown-document extensions and `manage_project()` board persistence) and returns the `shiny.appobj` Connect runs.
- `app.R` — the Connect entry point: `pkgload::load_all()` loads this package from the deployed bundle, then calls `blockr.uat::run_app()`. This is golem's deployment pattern; the file stays a thin loader.
- `DESCRIPTION` — runtime dependencies (`Imports:`). Two are declared for the Connect manifest rather than for direct use, because no upstream guarantees them: `ids`, so blockr.core's friendly board IDs are available, and `connectapi`, so blockr.session's default `user_pins_board` backend can exchange the Connect user session token for viewer-scoped pins. These show up in R CMD check's "All declared Imports should be used" NOTE — that is expected, not dead weight. Every blockr.* package is pinned to its GitHub main branch (`Remotes:`) so the deploy resolves development versions rather than stale CRAN/release builds.
- `.github/workflows/ci.yaml` — calls blockr.ci's reusable `ci.yaml` to gate PRs (lint, `R CMD check`, coverage, pkgdown).
- `.github/workflows/connect-deploy.yaml` — calls blockr.ci's reusable `connect-deploy` workflow (`@main`).

## How deployment works

Connect sits on an internal network a GitHub runner cannot reach, so deployment is pull-mode. On merge to a source branch (`main`), the `connect-deploy` workflow regenerates `manifest.json` from inside the merge queue and force-pushes it to a derived `connect-<base>` branch (`connect-main`) that Connect polls. Source branches stay manifest-free; only the `connect-*` branches carry the manifest.

The reusable workflow, the GitHub App / branch ruleset / protected environment it needs, and the one-time bootstrap are documented in [blockr.ci's Connect deployment setup](https://github.com/BristolMyersSquibb/blockr.ci#connect-deployment-setup).
