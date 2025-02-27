install_learners("classif.lssvm")
load_tests("classif.lssvm")

test_that("autotest", {
  set.seed(1)
  learner = lrn("classif.lssvm")
  expect_learner(learner)
  result = run_autotest(learner, exclude = "single", N = 50)
  expect_true(result, info = result$error)
})

test_that("classif.lssvm sigma", {
  learner = lrn("classif.lssvm", kpar = list(sigma = 0.2))
  t = tsk("iris")
  learner$train(t)
  expect_equal(learner$model@kernelf@kpar$sigma, 0.2)

  learner = lrn("classif.lssvm", sigma = 0.2)
  learner$train(t)
  expect_equal(learner$model@kernelf@kpar$sigma, 0.2)
})
