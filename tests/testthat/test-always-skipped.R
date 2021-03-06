if (FALSE) {

drake_context("always skipped")

test_with_dir("can keep going in parallel", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  plan <- drake_plan(
    a = stop(123),
    b = a + 1
  )
  make(
    plan, jobs = 2, session_info = FALSE, keep_going = TRUE, verbose = FALSE)
  expect_error(readd(a))
  expect_equal(readd(b), numeric(0))
})

test_with_dir("drake_debug()", {
  skip_on_cran()
  load_mtcars_example()
  my_plan$command[2] <- "simulate(48); stop(1234)"
  config <- drake_config(my_plan, lock_envir = TRUE)
  expect_error(make(my_plan), regexp = "1234")
  expect_error(drake_debug(), regexp = "1234")
  out <- drake_debug(large, config)
  out <- drake_debug("large", config, verbose = "false", character_only = TRUE)
  expect_true(is.data.frame(out))
  my_plan$command <- lapply(
    X = as.list(my_plan$command),
    FUN = function(x) {
      parse(text = x)[[1]]
    }
  )
  for (i in 1:2) {
    clean(destroy = TRUE)
    load_mtcars_example()
    make(my_plan)
    config <- drake_config(my_plan)
    expect_true(config$cache$exists("small"))
    clean(small)
    expect_false(config$cache$exists("small"))
    out <- drake_debug(small, config = config)
    expect_false(config$cache$exists("small"))
    expect_true(is.data.frame(out))
  }
})

test_with_dir("clustermq error messages get back to master", {
  plan <- drake_plan(a = stop(123))
  options(clustermq.scheduler = "multicore")
  for (caching in c("worker", "master")) {
    expect_error(
      make(
        plan,
        parallelism = "clustermq",
        caching = "worker"
      ),
      regexp = "123"
    )
  }
})

}
