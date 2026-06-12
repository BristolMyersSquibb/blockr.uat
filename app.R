library(blockr.core)

serve(
  new_board(
    blocks = c(
      bod = new_dataset_block("BOD"),
      chick = new_dataset_block("ChickWeight"),
      merged = new_merge_block("Time")
    ),
    links = c(
      bod_merged = new_link("bod", "merged", "x"),
      chick_merged = new_link("chick", "merged", "y")
    ),
    stacks = list(inputs = c("bod", "merged"))
  ),
  "blockr_uat"
)
