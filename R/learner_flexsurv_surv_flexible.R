#' @title Survival Flexible Parametric Spline Learner
#' @author RaphaelS1
#' @name mlr_learners_surv.flexible
#'
#' @template class_learner
#' @templateVar id surv.flexible
#' @templateVar caller flexsurvspline
#'
#' @details
#' The `distr` prediction is estimated using the fitted custom distributions
#' from [flexsurv::flexsurvspline()] and the estimated coefficients however the prediction takes
#' place in this package and not in \CRANpkg{flexsurv} for a much faster and more efficient
#' implementation.
#'
#' As flexible spline models estimate the baseline hazard as the intercept, the linear predictor,
#' `lp`, can be calculated as in the classical setting. i.e. For fitted coefficients,
#' \eqn{\beta = (\beta_0,...,\beta_P)}{\beta = (\beta0,...,\betaP)},
#' and covariates \eqn{X^T = (X_0,...,X_P)^T}{X^T = (X0,...,XP)^T}, where \eqn{X_0}{X0} is a column
#' of \eqn{1}s: \eqn{lp = \beta X}{lp = \betaX}.
#'
#' @section Custom mlr3 defaults:
#' - `k`:
#'   - Actual default: `0`
#'   - Adjusted default: `1`
#'   - Reason for change: The default value of `0` is equivalent to, and a much less efficient
#'   implementation of, [LearnerSurvParametric].
#'
#' @references
#' Royston P, Parmar MKB (2002).
#' “Flexible parametric proportional-hazards and proportional-odds models for censored survival
#' data, with application to prognostic modelling and estimation of treatment effects.”
#' Statistics in Medicine, 21(15), 2175–2197.
#' doi: 10.1002/sim.1203.
#'
#' @template seealso_learner
#' @template example
#' @export
LearnerSurvFlexible = R6Class("LearnerSurvFlexible",
  inherit = mlr3proba::LearnerSurv,

  public = list(
    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps = ps(
        bhazard = p_uty(tags = "train"),
        k = p_int(default = 0L, lower = 0L, tags = "train"),
        knots = p_uty(tags = "train"),
        bknots = p_uty(tags = "train"),
        scale = p_fct(default = "hazard", levels = c("hazard", "odds", "normal"), tags = "train"),
        timescale = p_fct(default = "log", levels = c("log", "identity"), tags = "train"),
        inits = p_uty(tags = "train"),
        rtrunc = p_uty(tags = "train"),
        fixedpars = p_uty(tags = "train"),
        cl = p_dbl(default = 0.95, lower = 0, upper = 1, tags = "train"),
        maxiter = p_int(default = 30L, tags = c("train", "control")),
        rel.tolerance = p_dbl(default = 1e-09, tags = c("train", "control")),
        toler.chol = p_dbl(default = 1e-10, tags = c("train", "control")),
        debug = p_int(default = 0, lower = 0, upper = 1, tags = c("train", "control")),
        outer.max = p_int(default = 10L, tags = c("train", "control"))
      )

      # value of k is changed as the default is equivalent (and a much more inefficient)
      # implementation of `surv.parametric`
      ps$values = list(k = 1)

      super$initialize(
        id = "surv.flexible",
        packages = c("mlr3extralearners", "flexsurv", "pracma"),
        feature_types = c("logical", "integer", "factor", "numeric"),
        predict_types = c("distr", "crank", "lp"),
        param_set = ps,
        properties = "weights",
        man = "mlr3extralearners::mlr_learners_surv.flexible"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pars_ctrl = self$param_set$get_values(tags = "control")
      pars_train = self$param_set$get_values(tags = "train")
      pars_train = pars_train[pars_train %nin% pars_ctrl]
      pars_train$sr.control = mlr3misc::invoke(survival::survreg.control, .args = pars_ctrl) #nolint

      if ("weights" %in% task$properties) {
        pars_train$weights = task$weights$weight
      }

      mlr3misc::invoke(flexsurv::flexsurvspline,
        formula = task$formula(task$feature_names),
        data = task$data(), .args = pars_train)
    },

    .predict = function(task) {

      # As we are using a custom predict method the missing assertions are performed here manually
      # (as opposed to the automatic assertions that take place after prediction)
      if (any(is.na(data.frame(task$data(cols = task$feature_names))))) {
        mlr3misc::stopf(
          "Learner %s on task %s failed to predict: Missing values in new data
                     (line(s) %s)\n",
          self$id, task$id,
          paste0(which(is.na(data.frame(task$data(cols = task$feature_names)))),
            collapse = ", "))
      }

      pred = mlr3misc::invoke(predict_flexsurvreg, self$model, task)

      # crank is defined as the mean of the survival distribution
      list(distr = pred$distr, lp = pred$lp, crank = pred$lp)
    }
  )
)

predict_flexsurvreg <- function(object, task, ...) {

  # define newdata from the supplied task and convert to model matrix

  newdata = task$data(cols = task$feature_names)
  X = stats::model.matrix(formulate(rhs = task$feature_names),
                          data = newdata,
                          xlev = task$levels())

  # collect the auxiliary arguments for the fitted object
  args <- object$aux
  args$knots <- as.numeric(args$knots)

  # define matrix of coeffs coefficients
  coeffs = matrix(object$coefficients[c("gamma0", colnames(X)[-1])], nrow = 1)

  # collect fitted parameters
  pars = matrix(object$res.t[object$dlist$pars, "est"],
                nrow = nrow(newdata),
                ncol = length(object$dlist$pars), byrow = TRUE)
  colnames(pars) = object$dlist$pars

  # calculate the linear predictor as X\beta, note intercept not included in model.matrix
  # so added manually
  pars[, "gamma0"] <- coeffs %*% t(X)

  # if any inverse transformations exist then apply them
  invs = sapply(object$dlist$inv.transforms, function(tr) body(tr) != "x")
  if (any(invs)) {
    for (i in which(invs)) {
      pars[, i] <- object$dlist$inv.transforms[[i]](pars[, i])
    }
  }

  # once inverse transformed we can collect the linear predictor
  lp = pars[, "gamma0"]

  # Define the d/p/q/r methods using the d/p/q/r methods that are automatically generated in the
  # fitted object. The parameters referenced are defined below and are based on the gamma
  # parameters above.
  pdf = function(x) {} # nolint
  body(pdf) = substitute({
    do.call(func, c(list(x = x), self$parameters()$values))
  }, list(func = object$dfns$d))

  cdf = function(x) {} # nolint
  body(cdf) = substitute({
    do.call(func, c(list(q = x), self$parameters()$values))
  }, list(func = object$dfns$p))

  quantile = function(p) {} # nolint
  body(quantile) = substitute({
    do.call(func, c(list(p = p), self$parameters()$values))
  }, list(func = object$dfns$q))

  rand = function(n) {} # nolint
  body(rand) = substitute({
    do.call(func, c(list(n = n), self$parameters()$values))
  }, list(func = object$dfns$r))

  # The parameter set combines the auxiliary parameters with the fitted gamma coefficients.
  # Whilst the user can set these after fitting, this is generally ill-advised.
  parameters = param6::ParameterSet$new(c(list(
    param6::prm(
      "knots", set6::Reals$new()^length(object$knots),
      numeric(length(object$knots))
    ),
    param6::prm("scale", set6::Set$new("hazard", "odds", "normal"), "hazard"),
    param6::prm("timescale", set6::Set$new("log", "identity"), "log")),
    lapply(object$dlist$pars, function(x) param6::prm(x, "reals", 0))
  ))

  pars = data.table::data.table(t(pars))
  pargs = data.table::data.table(matrix(args, ncol = ncol(pars), nrow = length(args)))
  pars = rbind(pars, pargs)

  shared_params = list(
    name = "Flexible Parameteric",
    short_name = "Flexsurv",
    type = set6::PosReals$new(),
    support = set6::PosReals$new(),
    valueSupport = "continuous",
    variateForm = "univariate",
    description = "Royston/Parmar Flexible Parametric Survival Model",
    .suppressChecks = TRUE,
    pdf = pdf, cdf = cdf, quantile = quantile, rand = rand
  )

  ## FIXME - This is bad and needs speeding up
  distlist = lapply(pars, function(x) {
    yparams = parameters$clone(deep = TRUE)
    yparams$values = setNames(as.list(x), c(object$dlist$pars, names(args)))

    do.call(distr6::Distribution$new, c(list(parameters = yparams), shared_params))
  })

  distr = distr6::VectorDistribution$new(
    distlist, decorators = c("CoreStatistics", "ExoticStatistics"))

  return(list(distr = distr, lp = lp))
}

.extralrns_dict$add("surv.flexible", LearnerSurvFlexible)
