create_drake_graph <- function(
  layout,
  targets,
  cache,
  jobs,
  console_log_file,
  verbose,
  collapse = TRUE
) {
  config <- list(
    jobs = jobs,
    verbose = verbose,
    console_log_file = console_log_file
  )
  edges <- memo_expr(
    cdg_create_edges(config, layout, collapse),
    cache,
    config,
    layout,
    collapse
  )
  memo_expr(
    cdg_finalize_graph(edges, targets, config, collapse),
    cache,
    edges,
    targets
  )
}

cdg_create_edges <- function(config, layout, collapse) {
  console_preprocess(text = "construct graph edges", config = config)
  edges <- lightly_parallelize(
    X = layout,
    FUN = node_to_edges,
    jobs = config$jobs
  )
  edges <- do.call(rbind, edges)
  if (collapse) {
    edges <- collapse_edges(edges)
  }
  edges
}

node_to_edges <- function(node) {
  file_out <- node$deps_build$file_out
  node$deps_build$file_out <- NULL
  inputs <- clean_dependency_list(
    c(node$deps_build, node$deps_condition, node$deps_change)
  )
  out <- NULL
  if (length(inputs)) {
    out <- weak_tibble(from = inputs, to = node$target, collapse = FALSE)
  }
  if (length(file_out)) {
    out <- rbind(
      out,
      weak_tibble(from = node$target, to = file_out, collapse = TRUE)
    )
  }
  if (is.null(out)) {
    out <- weak_tibble(
      from = node$target,
      to = node$target,
      collapse = FALSE
    )
  }
  out
}

collapse_edges <- function(edges) {
  which_collapse <- which(edges$collapse)
  for (index in which_collapse){
    to <- edges$to[index]
    edges$from[edges$from == to] <- edges$from[index]
  }
  edges$to[edges$collapse] <- edges$from[edges$collapse]
  edges
}

cdg_finalize_graph <- function(edges, targets, config, collapse) {
  console_preprocess(text = "construct graph", config = config)
  if (!collapse) {
    targets <- c(
      targets,
      edges$to[edges$collapse & (edges$from %in% targets)]
    )
  }
  graph <- igraph::graph_from_data_frame(edges[, c("from", "to")])
  graph <- prune_drake_graph(graph, to = targets, jobs = config$jobs)
  igraph::simplify(
    graph,
    remove.loops = TRUE,
    remove.multiple = TRUE,
    edge.attr.comb = "min"
  )
}
