user_pins_board <- function(session = shiny::getDefaultReactiveDomain()) {

  token <- user_session_token(session)

  if (is.null(token)) {
    return(pins::board_local())
  }

  con <- connectapi::connect(token = token)

  pins::board_connect(
    auth = "manual",
    server = Sys.getenv("CONNECT_SERVER"),
    key = con$api_key
  )
}

user_session_token <- function(session) {

  token <- session$request$HTTP_POSIT_CONNECT_USER_SESSION_TOKEN

  if (is.null(token) || !nzchar(token)) {
    return(NULL)
  }

  token
}
