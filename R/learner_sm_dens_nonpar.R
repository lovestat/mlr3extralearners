#' @title Density Nonparametric Learner
#' @name mlr_learners_dens.nonpar
#' @author RaphaelS1
#'
#' @template class_learner
#' @templateVar id dens.nonpar
#' @templateVar caller sm.density
#'
#' @references
#' Bowman, A.W. and Azzalini, A. (1997).
#' Applied Smoothing Techniques for Data Analysis: the Kernel Approach with S-Plus Illustrations.
#' Oxford University Press, Oxford.
#'
#' @template seealso_learner
#' @template example
#' @export
LearnerDensNonparametric = R6Class("LearnerDensNonparametric",
  inherit = mlr3proba::LearnerDens,

  public = list(
    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
          h = p_dbl(tags = "train"),
          group = p_uty(tags = "train"),
          delta = p_dbl(tags = "train"),
          h.weights = p_dbl(default = 1, tags = "train"),
          hmult = p_uty(default = 1, tags = "train"),
          method = p_fct(default = "normal",
            levels = c("normal", "cv", "sj", "df", "aicc"), tags = "train"),
          positive = p_lgl(default = FALSE, tags = "train"),
          verbose = p_uty(default = 1, tags = "train")
      )

      super$initialize(
        id = "dens.nonpar",
        packages = c("mlr3extralearners", "sm"),
        feature_types = c("integer", "numeric"),
        predict_types = "pdf",
        param_set = ps,
        properties = "weights",
        man = "mlr3extralearners::mlr_learners_dens.nonpar"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pars = self$param_set$get_values(tag = "train")

      if ("weights" %in% task$properties) {
        pars$weights = task$weights$weight
      }

      pdf = function(x) {} # nolint
      body(pdf) = substitute({
        mlr3misc::invoke(sm::sm.density,
          x = data, eval.points = x, display = "none", show.script = FALSE,
          .args = pars)$estimate
      }, list(data = task$data(cols = task$feature_names)[[1]]))

      distr6::Distribution$new(
        name = "Nonparametric Density",
        short_name = "NonparDens",
        type = set6::Reals$new(),
        pdf = pdf)
    },

    .predict = function(task) {
      list(pdf = self$model$pdf(task$data(cols = task$feature_names)[[1]]))
    }
  )
)

.extralrns_dict$add("dens.nonpar", LearnerDensNonparametric)
