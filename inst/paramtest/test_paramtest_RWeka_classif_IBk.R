library(mlr3extralearners)
mlr3extralearners::install_learners("classif.IBk")

test_that("classif.IBk", {
  learner = lrn("classif.IBk")
  fun = RWeka::IBk
  exclude = weka_control_args(RWeka::IBk)
  # formula and data are handled via mlr3
  # mlr3 does not have the `control` argument because the parameters can be specified directly
  exclude = c("formula", "data", "control", exclude)
  ParamTest = run_paramtest(learner, fun, exclude)
  expect_true(ParamTest)
})

test_that("Weka_control IBk", {
  # Here we test that the learner implements those arguments that are passed via the
  # control argument to RWeka::IBk
  learner = lrn("classif.IBk")
  control_args = weka_control_args(RWeka::IBk)
  expect_true(all(control_args %in% learner$param_set$ids()))
})


test_that("Parameters can be set", {
  learner = lrn("classif.IBk")
  learner$param_set$values = learner$param_set$default
  task = tsk("iris")
  expect_error(learner$train(task), NA)
})

