# Connect entry point. Loads this package from the deployed bundle without
# installing it (the golem deployment pattern) and launches. The app logic
# lives in R/run_app.R; keep this file a thin loader.
pkgload::load_all(export_all = FALSE, helpers = FALSE, attach_testthat = FALSE)

blockr.uat::run_app()
