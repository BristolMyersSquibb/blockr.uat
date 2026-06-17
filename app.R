library(blockr)
library(blockr.assistant)
library(blockr.md)
library(blockr.session)

# On Connect, persist boards to the Connect pin store; the manage_project()
# default board_local() is per-container and ephemeral there. Locally there
# are no Connect credentials, so fall back to that default and still boot.
if (nzchar(Sys.getenv("CONNECT_SERVER"))) {
  options(blockr.session_mgmt_backend = pins::board_connect)
}

run_app(
  blocks = c(
    data = new_dataset_block("mtcars"),
    plot = new_ggplot_block(type = "point", x = "hp", y = "mpg")
  ),
  links = new_link("data", "plot", "data"),
  extensions = list(
    dag = new_dag_extension(),
    assistant = new_assistant_extension(),
    doc = new_md_extension(
      c(
        "# blockr UAT",
        "",
        "Horsepower against fuel economy, embedded live from the board:",
        "",
        "![Horsepower vs. miles per gallon](blockr://plot)"
      )
    )
  ),
  plugins = custom_plugins(manage_project()),
  id = "blockr_uat"
)
