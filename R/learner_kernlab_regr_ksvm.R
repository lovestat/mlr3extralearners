#' @title Regression Kernlab Support Vector Machine
#' @author mboecker
#' @name mlr_learners_regr.ksvm
#'
#' @template class_learner
#' @templateVar id regr.ksvm
#' @templateVar caller ksvm
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerRegrKSVM = R6Class("LearnerRegrKSVM",
  inherit = LearnerRegr,
  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        scaled = p_lgl(default = TRUE, tags = "train"),
        type = p_fct(default = "eps-svr",
          levels = c("eps-svr", "nu-svr", "eps-bsvr"), tags = "train"),
        kernel = p_fct(default = "rbfdot",
          levels = c(
            "rbfdot", "polydot", "vanilladot",
            "laplacedot", "besseldot", "anovadot"),
          tags = "train"),
        C = p_dbl(default = 1, tags = "train"),
        nu = p_dbl(default = 0.2, lower = 0, tags = "train"),
        epsilon = p_dbl(default = 0.1, tags = "train"),
        cache = p_int(default = 40, lower = 1L, tags = "train"),
        tol = p_dbl(default = 0.001, lower = 0, tags = "train"),
        shrinking = p_lgl(default = TRUE, tags = "train"),
        sigma = p_dbl(default = NO_DEF, lower = 0, tags = "train"),
        degree = p_int(default = NO_DEF, lower = 1L,
          tags = "train"),
        scale = p_dbl(default = NO_DEF, lower = 0, tags = "train"),
        order = p_int(default = NO_DEF, tags = "train"),
        offset = p_dbl(default = NO_DEF, tags = "train")
      )

      ps$add_dep("C", "type", CondAnyOf$new(c("eps-svr", "eps-bsvr", "nu-svr")))
      ps$add_dep("nu", "type", CondAnyOf$new(c("nu-svr")))
      ps$add_dep(
        "epsilon", "type",
        CondAnyOf$new(c("eps-svr", "nu-svr", "eps-bsvr")))

      ps$add_dep(
        "sigma", "kernel",
        CondAnyOf$new(c("rbfdot", "laplacedot", "besseldot", "anovadot")))
      ps$add_dep(
        "degree", "kernel",
        CondAnyOf$new(c("polydot", "besseldot", "anovadot")))
      ps$add_dep("scale", "kernel", CondAnyOf$new(c("polydot")))
      ps$add_dep("order", "kernel", CondAnyOf$new(c("besseldot")))
      ps$add_dep("offset", "kernel", CondAnyOf$new(c("polydot")))

      super$initialize(
        id = "regr.ksvm",
        packages = c("mlr3extralearners", "kernlab"),
        feature_types = c(
          "logical", "integer", "numeric",
          "character", "factor", "ordered"),
        predict_types = "response",
        param_set = ps,
        properties = "weights",
        man = "mlr3extralearners::mlr_learners_regr.ksvm"
      )
    }),

  private = list(
    .train = function(task) {
      pars = self$param_set$get_values(tags = "train")
      kpar = intersect(
        c("sigma", "degree", "scale", "order", "offset"),
        names(pars))

      if ("weights" %in% task$properties) {
        pars$class.weights = task$weights$weight
      }

      if (length(kpar) > 0) {
        pars$kpar = pars[kpar]
        pars[kpar] = NULL
      }

      f = task$formula()
      data = task$data()

      invoke(kernlab::ksvm, x = f, data = data, .args = pars)
    },

    .predict = function(task) {
      newdata = task$data(cols = task$feature_names)

      p = invoke(kernlab::predict, self$model,
        newdata = newdata,
        type = "response")
      list(response = p)
    }
  )
)

.extralrns_dict$add("regr.ksvm", LearnerRegrKSVM)
