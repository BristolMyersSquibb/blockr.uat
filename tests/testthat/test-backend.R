test_that("user_session_token() reads the Connect user session token", {
  session <- list(
    request = list(HTTP_POSIT_CONNECT_USER_SESSION_TOKEN = "tok-abc")
  )

  expect_identical(user_session_token(session), "tok-abc")
})

test_that("user_session_token() returns NULL when no usable token is present", {
  expect_null(user_session_token(NULL))
  expect_null(user_session_token(list(request = list())))
  expect_null(
    user_session_token(
      list(request = list(HTTP_POSIT_CONNECT_USER_SESSION_TOKEN = ""))
    )
  )
})

test_that("user_pins_board() falls back to a local board without a token", {
  expect_s3_class(user_pins_board(NULL), "pins_board")
})

test_that("user_pins_board() builds a visitor-scoped Connect board", {
  local_mocked_bindings(
    connect = function(token, ...) list(api_key = paste0("key-", token)),
    .package = "connectapi"
  )
  local_mocked_bindings(
    board_connect = function(auth, server, key, ...) {
      structure(
        list(auth = auth, server = server, key = key),
        class = "pins_board"
      )
    },
    .package = "pins"
  )
  withr::local_envvar(CONNECT_SERVER = "https://connect.example.com")

  session <- list(
    request = list(HTTP_POSIT_CONNECT_USER_SESSION_TOKEN = "tok-abc")
  )

  board <- user_pins_board(session)

  expect_s3_class(board, "pins_board")
  expect_identical(board$auth, "manual")
  expect_identical(board$server, "https://connect.example.com")
  expect_identical(board$key, "key-tok-abc")
})
