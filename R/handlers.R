handle_build_exceptions <- function(target, meta, config) {
  if (length(meta$warnings) && config$verbose) {
    warn_opt <- max(1, getOption("warn"))
    with_options(
      new = list(warn = warn_opt),
      warning(
        "target ", target, " warnings:\n",
        multiline_message(meta$warnings),
        call. = FALSE
      )
    )
  }
  if (length(meta$messages) && config$verbose) {
    message(
      "Target ", target, " messages:\n",
      multiline_message(meta$messages)
    )
  }
  if (inherits(meta$error, "error")) {
    if (config$verbose) {
      text <- paste("fail", target)
      finish_console(text = text, pattern = "fail", config = config)
    }
    store_failure(target = target, meta = meta, config = config)
    if (!config$keep_going) {
      drake_error(
        "Target `", target, "` failed. Call `diagnose(", target,
        ")` for details. Error message:\n  ",
        meta$error$message,
        config = config
      )
    }
  }
}

error_character0 <- function(e) {
  character(0)
}

error_false <- function(e) {
  FALSE
}

error_na <- function(e) {
  NA_character_
}

error_null <- function(e) {
  NULL
}

error_tibble_times <- function(e) {
  stop(
    "Failed converting a data frame of times to a tibble. ",
    "Please install version 1.2.1 or greater of the pillar package.",
    call. = FALSE
  )
}

error_process <- function(e, id, config) {
  stack <- sys.calls()
  drake_warning("Error: ", e$message, config = config)
  drake_warning("Call: ", e$call, config = config)
  config$cache$set(
    key = id,
    value = list(error = e, stack = stack),
    namespace = "mc_error"
  )
  set_attempt_flag(key = id, config = config)
}

# Should be used as sparingly as possible.
just_try <- function(code) {
  try(suppressWarnings(code), silent = TRUE)
}

mention_pure_functions <- function(e) {
  msg1 <- "cannot change value of locked binding"
  msg2 <- "cannot add bindings to a locked environment"
  locked_envir <- grepl(msg1, e$message) || grepl(msg2, e$message)
  if (locked_envir) {
    e$message <- paste0(e$message, ". ", locked_envir_msg)
  }
  e
}

locked_envir_msg <- paste(
  "One of your functions or drake plan commands may have tried",
  "to modify an object in your environment/workspace/R session.",
  "drake stops you from doing this sort of thing because it",
  "invalidates upstream targets and undermines reproducibility.",
  "Please verify that all your commands and functions are pure:",
  "they should only produce *new* output, and",
  "they should never go back and modify old output or dependencies.",
  "Beware <<-, ->>, attach(), and data().",
  "Also please try to avoid options() even though drake does not stop you.",
  "Alternatively, you can set lock_envir to FALSE in make() or",
  "drake_config() to stop drake from producing these errors. But be warned:",
  "make(lock_envir = FALSE) decreases the levels of confidence and trust",
  "you can place in your results."
)
