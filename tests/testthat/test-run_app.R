test_that("run_app() builds a shiny app object", {
  expect_s3_class(run_app(), "shiny.appobj")
})

test_that("run_app() registers the user-namespaced backend on Connect", {
  withr::local_envvar(CONNECT_SERVER = "https://connect.example.com")
  withr::local_options(blockr.session_mgmt_backend = NULL)

  app <- run_app()

  expect_s3_class(app, "shiny.appobj")
  expect_identical(getOption("blockr.session_mgmt_backend"), user_pins_board)
})
