# Connect entry point. Loads this package from the deployed bundle without
# installing it (the golem deployment pattern) and launches. The app logic
# lives in R/run_app.R; keep this file a thin loader.
pkgload::load_all(export_all = FALSE, helpers = FALSE, attach_testthat = FALSE)

# Launch at debug level so blockr.session's pin instrumentation reaches the
# logs. The pull-based deploy can't set env vars, so the level is set here
# rather than via BLOCKR_LOG_LEVEL.
options(blockr.log_level = "debug")

blockr.uat::run_app()
