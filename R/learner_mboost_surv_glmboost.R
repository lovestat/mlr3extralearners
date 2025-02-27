#' @title Boosted Generalized Linear Survival Learner
#' @author RaphaelS1
#'
#' @name mlr_learners_surv.glmboost
#'
#' @template class_learner
#' @templateVar id surv.glmboost
#' @templateVar caller glmboost
#'
#' @details
#' `distr` prediction made by [mboost::survFit()].
#'
#' @references
#' Bühlmann P, Yu B (2003).
#' “Boosting With the L2 Loss.”
#' Journal of the American Statistical Association, 98(462), 324–339.
#' \doi{10.1198/016214503000125}
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerSurvGLMBoost = R6Class("LearnerSurvGLMBoost",
  inherit = mlr3proba::LearnerSurv,
  public = list(
    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
          offset = p_dbl(tags = "train"),
          family = p_fct(default = "coxph",
            levels = c(
              "coxph", "weibull", "loglog", "lognormal", "gehan", "cindex",
              "custom"), tags = "train"),
          custom.family = p_uty(tags = "train"),
          nuirange = p_uty(default = c(0, 100), tags = "train"),
          center = p_lgl(default = TRUE, tags = "train"),
          mstop = p_int(default = 100L, lower = 0L, tags = "train"),
          nu = p_dbl(default = 0.1, lower = 0, upper = 1, tags = "train"),
          risk = p_fct(default = "inbag",
            levels = c("inbag", "oobag", "none"), tags = "train"),
          oobweights = p_uty(default = NULL, tags = "train"),
          stopintern = p_lgl(default = FALSE, tags = "train"),
          trace = p_lgl(default = FALSE, tags = "train"),
          sigma = p_dbl(default = 0.1, lower = 0, upper = 1,
            tags = "train"),
          ipcw = p_uty(default = 1, tags = "train"),
          na.action = p_uty(default = stats::na.omit, tags = "train"),
          contrasts.arg = p_uty(tags = "train")
      )

      ps$values = list(family = "coxph")
      ps$add_dep("sigma", "family", CondEqual$new("cindex"))
      ps$add_dep("ipcw", "family", CondEqual$new("cindex"))
      ps$add_dep("oobweights", "risk", CondEqual$new("oobag"))

      super$initialize(
        id = "surv.glmboost",
        param_set = ps,
        feature_types = c("integer", "numeric", "factor", "logical"),
        predict_types = c("distr", "crank", "lp"),
        properties = "weights",
        packages = c("mlr3extralearners", "mboost", "pracma"),
        man = "mlr3extralearners::mlr_learners_surv.glmboost"
      )
    }

    #' Importance is supported but fails tests as internally data
    #' is coerced to model
    #' matrix and original names can't be recovered.
    #'
    # importance = function() {
    #   if (is.null(self$model)) {
    #     stopf("No model stored")
    #   }
    #
    #   sort(mboost::varimp(self$model)[-1], decreasing = TRUE)
    # },

    #' Importance is supported but fails tests as internally data
    #' is coerced to model
    #' matrix and original names can't be recovered.
    #'
    #' description
    #' Selected features are extracted with the function
    #' [mboost::variable.names.mboost()], with
    #' `used.only = TRUE`.
    #' return `character()`.
    # selected_features = function() {
    #   if (is.null(self$model)) {
    #     stopf("No model stored")
    #   }
    #
    #   sel = unique(names(self$model$model.frame())[self$model$xselect()])
    #   sel = sel[!(sel %in% "(Intercept)")]
    #
    #   return(sel)
    # }
  ),

  private = list(
    .train = function(task) {

      # parameter custom.family takes precedence over family
      if (!is.null(self$param_set$values$custom.family)) {
        self$param_set$values$family = "custom"
      }

      pars = self$param_set$get_values(tags = "train")

      saved_ctrl = mboost::boost_control()
      on.exit(mlr3misc::invoke(mboost::boost_control, .args = saved_ctrl))
      is_ctrl_pars = (names(pars) %in% names(saved_ctrl))

      # ensure only relevant pars passed to fitted model
      if (any(is_ctrl_pars)) {
        pars$control = do.call(mboost::boost_control, pars[is_ctrl_pars])
        pars = pars[!is_ctrl_pars]
      }

      if ("weights" %in% task$properties) {
        pars$weights = task$weights$weight
      }

      family = switch(pars$family,
        coxph = mboost::CoxPH(),
        weibull = mlr3misc::invoke(mboost::Weibull,
          .args = pars[names(pars) %in% methods::formalArgs(mboost::Weibull)]),
        loglog = mlr3misc::invoke(mboost::Loglog,
          .args = pars[names(pars) %in% methods::formalArgs(mboost::Loglog)]),
        lognormal = mlr3misc::invoke(mboost::Lognormal,
          .args = pars[names(pars) %in% methods::formalArgs(mboost::Lognormal)]),
        gehan = mboost::Gehan(),
        cindex = mlr3misc::invoke(mboost::Cindex,
          .args = pars[names(pars) %in% methods::formalArgs(mboost::Cindex)]),
        custom = pars$custom.family
      )

      # FIXME - until issue closes
      pars = pars[!(names(pars) %in% methods::formalArgs(mboost::Weibull))]
      pars = pars[!(names(pars) %in% methods::formalArgs(mboost::Cindex))]
      pars = pars[!(names(pars) %in% c("family", "custom.family"))]

      mlr3misc::invoke(mboost::glmboost, task$formula(task$feature_names),
        data = task$data(), family = family, .args = pars)
    },

    .predict = function(task) {

      newdata = task$data(cols = task$feature_names)
      # predict linear predictor
      lp = as.numeric(mlr3misc::invoke(predict, self$model, newdata = newdata, type = "link"))

      # predict survival
      if (is.null(self$param_set$values$family) || self$param_set$values$family == "coxph") {
        survfit = mlr3misc::invoke(mboost::survFit, self$model, newdata = newdata)

        mlr3proba::.surv_return(times = survfit$time,
                                surv = t(survfit$surv),
                                lp = lp)
      } else {
        mlr3proba::.surv_return(lp = -lp)
      }


      # FIXME - RE-ADD ONCE INTERPRETATION IS CLEAR
      # response = NULL
      # if (!is.null(self$param_set$values$family)) {
      #   if (self$param_set$values$family %in% c("weibull", "loglog", "lognormal", "gehan")) {
      #     response = exp(lp)
      #   }
      # }
    }
  )
)

.extralrns_dict$add("surv.glmboost", LearnerSurvGLMBoost)
