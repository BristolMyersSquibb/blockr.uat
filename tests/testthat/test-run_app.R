test_that("run_app() builds a shiny app object", {
  expect_s3_class(run_app(), "shiny.appobj")
})
