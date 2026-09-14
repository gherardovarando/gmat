## Resubmission (0.2.3)

This resubmission fixes the test failures that caused removal from CRAN in
September 2023. The root cause was an undeclared dependency on the Bioconductor
`graph` package, which was required by `igraph::as_graphnel()` (used internally
by `gRbase::triangulate()`, `gRbase::mcs()`, and `gRbase::topoSort()`).
On Fedora-based CRAN check platforms where `graph` is not installed, this caused:
- 11 test failures on r-devel-linux-x86_64-fedora-clang ("there is no package called 'graph'")
- 2 test failures on r-devel-linux-x86_64-fedora-gcc ("no method or default for coercing 'graphNEL' to 'dgCMatrix'")

The fix replaces all `gRbase`/`graphNEL`-dependent code with pure `igraph` equivalents:
- `gRbase::triangulate()` → `igraph::is_chordal(newgraph = TRUE)$newgraph`
- `gRbase::mcs()` → `igraph::max_cardinality()$alpham1`
- `gRbase::topoSort()` → `igraph::topo_sort()`

`gRbase` has been removed from `Imports`.

## Test environments
* GitHub Actions: ubuntu-latest (R devel, release, oldrel-1), macOS-latest (release), windows-latest (release)

## R CMD check results
There are no ERRORs, WARNINGs or NOTEs.

## Downstream dependencies
There are currently no downstream dependencies for this package.
