# blockr.uat

A blockr board deployed to Posit Connect for user acceptance testing, published via blockr.ci's pull-mode `connect-deploy` pipeline.

## Contents

- `app.R` — a blockr board (`serve(new_board(...))`); `serve.board()` returns a `shinyApp` object, which is what Connect runs.
- `DESCRIPTION` — declares runtime dependencies (`Imports: blockr.core`) so the deploy workflow resolves them from the package metadata.
- `.github/workflows/connect-deploy.yaml` — calls the reusable `connect-deploy` workflow in `cynkra/blockr.ci`.

## How deployment works

Connect sits on an internal network a GitHub runner cannot reach, so deployment is pull-mode. On merge to a source branch (`main`), the `connect-deploy` workflow regenerates `manifest.json` from inside the merge queue and force-pushes it to a derived `connect-<base>` branch (`connect-main`) that Connect polls. Source branches stay manifest-free; only the `connect-*` branches carry the manifest.

The reusable workflow, the GitHub App / branch ruleset / protected environment it needs, and the one-time bootstrap are documented in [blockr.ci's Connect deployment setup](https://github.com/cynkra/blockr.ci#connect-deployment-setup).
