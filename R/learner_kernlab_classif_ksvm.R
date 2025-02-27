#' @title Classification Kernlab Support Vector Machine
#' @author mboecker
#' @name mlr_learners_classif.ksvm
#'
#' @template class_learner
#' @templateVar id classif.ksvm
#' @templateVar caller ksvm
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerClassifKSVM = R6Class("LearnerClassifKSVM",
  inherit = LearnerClassif,
  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        scaled = p_lgl(default = TRUE, tags = c("train")),
        type = p_fct(default = "C-svc",
          levels = c("C-svc", "nu-svc", "C-bsvc", "spoc-svc", "kbb-svc"),
          tags = c("train")),
        kernel = p_fct(default = "rbfdot",
          levels = c(
            "rbfdot", "polydot", "vanilladot",
            "laplacedot", "besseldot", "anovadot"),
          tags = c("train")),
        C = p_dbl(default = 1, tags = c("train")),
        nu = p_dbl(default = 0.2, lower = 0, tags = c("train")),
        cache = p_int(default = 40, lower = 1L, tags = c("train")),
        tol = p_dbl(default = 0.001, lower = 0, tags = c("train")),
        shrinking = p_lgl(default = TRUE, tags = c("train")),
        sigma = p_dbl(default = NO_DEF, lower = 0, tags = "train"),
        degree = p_int(default = NO_DEF, lower = 1L,
          tags = "train"),
        scale = p_dbl(default = NO_DEF, lower = 0, tags = "train"),
        order = p_int(default = NO_DEF, tags = "train"),
        offset = p_dbl(default = NO_DEF, tags = "train")
      )

      ps$add_dep(
        "C", "type",
        CondAnyOf$new(c("C-svc", "C-bsvc", "spoc-svc", "kbb-svc")))
      ps$add_dep("nu", "type", CondAnyOf$new(c("nu-svc")))
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
        id = "classif.ksvm",
        packages = c("mlr3extralearners", "kernlab"),
        feature_types = c(
          "logical", "integer", "numeric",
          "character", "factor", "ordered"),
        predict_types = c("response", "prob"),
        param_set = ps,
        properties = c("weights", "twoclass", "multiclass"),
        man = "mlr3extralearners::mlr_learners_classif.ksvm"
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

      invoke(kernlab::ksvm,
        x = f, data = data,
        prob.model = self$predict_type == "prob", .args = pars)
    },

    .predict = function(task) {
      newdata = task$data(cols = task$feature_names)

      predict_type = ifelse(self$predict_type == "prob",
        "probabilities", "response")
      p = invoke(kernlab::predict, self$model,
        newdata = newdata,
        type = predict_type)

      if (self$predict_type == "response") {
        list(response = p)
      } else {
        list(prob = p)
      }
    }
  )
)

.extralrns_dict$add("classif.ksvm", LearnerClassifKSVM)
