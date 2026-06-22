#' Launch the blockr UAT app
#'
#' Builds the blockr dock board served for user acceptance testing on Posit
#' Connect: an `mtcars` dataset block feeding a ggplot point block, with the
#' DAG, assistant and markdown-document extensions and board persistence. On
#' Connect (`CONNECT_SERVER` set) persistence uses the Connect pin store;
#' elsewhere it keeps the per-container default so the app still boots locally.
#'
#' @return The `shiny.appobj` that Connect runs.
#' @export
run_app <- function() {

  if (nzchar(Sys.getenv("CONNECT_SERVER"))) {
    options(blockr.session_mgmt_backend = pins::board_connect)
  }

  blockr::run_app(
    blocks = c(
      data = blockr.core::new_dataset_block("mtcars"),
      plot = blockr.ggplot::new_ggplot_block(
        type = "point", x = "hp", y = "mpg"
      )
    ),
    links = blockr.core::new_link("data", "plot", "data"),
    extensions = list(
      dag = blockr.dag::new_dag_extension(),
      assistant = blockr.assistant::new_assistant_extension(),
      doc = blockr.md::new_md_extension(
        c(
          "# blockr UAT",
          "",
          "Horsepower against fuel economy, embedded live from the board:",
          "",
          "![Horsepower vs. miles per gallon](blockr://plot)"
        )
      )
    ),
    plugins = blockr.core::custom_plugins(blockr.session::manage_project()),
    id = "blockr_uat"
  )
}
