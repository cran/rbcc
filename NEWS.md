# rbcc 0.2.1

## Documentation

* Added a complete, executable getting-started vignette that presents the
  paired-measurement workflow, the four decision costs, all supported chart
  families, exact optimization, alternative optimizers, optional parallel grid
  evaluation, and the multivariate example.
* Expanded the README with the vignette entry point and CRAN-oriented examples.
* Updated the package citation to version 0.2.1.

## Quality assurance

* Added an independent regression test that compares the exact optimizer with
  exhaustive evaluation of all empirical X-bar threshold events.
* Added a cross-platform regression test that checks equality of sequential and
  parallel grid-search results. The default check uses one worker for maximum
  portability; a two-worker path can be enabled with
  `RBCC_RUN_PARALLEL_TESTS=true`.

## Compatibility

* No exported function signatures or default chart calculations changed in
  this release.
