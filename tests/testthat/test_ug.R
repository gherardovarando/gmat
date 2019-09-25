context("Possible zero pattern represented by a UG")

test_that("selective gram schmidt actually selects", {
  p <- 5
  d <- 0.25

  span <- matrix(ncol = p, nrow = p, stats::rnorm(p^2))

  ug <- rgraph(p = p, d = d)
  madj <- igraph::as_adjacency_matrix(ug, type = "both", sparse = FALSE)

  span_ort <- .Call(C_gram_schmidt_sel, madj, t(span))

  span_dot_prod <- crossprod(span_ort)
  madj_learned <- (zapsmall(span_dot_prod) != 0) * 1
  diag(madj_learned) <- 0
  expect_equal(length(which((madj_learned - madj) != 0)), 0)
})

test_that("the graph structure is preserved", {
  p <- 50
  d <- 0.2

  expect_equal_ug <- function(m, ug) {
    madj <- igraph::as_adjacency_matrix(ug, sparse = FALSE)
    madj_learned <- zapsmall(m) != 0
    diag(madj_learned) <- FALSE
    expect_equal(length(which((madj - madj_learned) != 0)), 0)
  }

  ug <- rgraph(p = p, d = d)

  sample <- port(ug = ug)
  expect_equal_ug(m = sample[, , 1], ug = ug)

  sample <- diagdom(ug = ug)
  expect_equal_ug(m = sample[, , 1], ug = ug)

  sample <- port_chol(ug = ug)
  expect_equal_ug(m = sample[, , 1], ug = ug)
})