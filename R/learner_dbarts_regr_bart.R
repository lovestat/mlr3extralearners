#' @title Regression BART (Bayesian Additive Regression Trees) Learner
#' @author ck37
#' @name mlr_learners_regr.bart
#'
#' @template class_learner
#' @templateVar id regr.bart
#' @templateVar caller bart
#'
#' @section Custom mlr3 defaults:
#' * Parameter: keeptrees
#' * Original: FALSE
#' * New: TRUE
#' * Reason: Required for prediction
#'
#' @template seealso_learner
#' @template example
#' @export
LearnerRegrBart <- R6Class("LearnerRegrBart",
  inherit = LearnerRegr,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      ps <- ps(
        ntree = p_int(default = 200L, lower = 1L, tags = "train"),
        sigest = p_uty(default = NULL, tags = "train"),
        sigdf = p_int(default = 3L, lower = 1L, tags = "train"),
        sigquant = p_dbl(default = 0.90, lower = 0, upper = 1, tags = "train"),
        k = p_dbl(default = 2.0, lower = 0, tags = "train"),
        power = p_dbl(default = 2.0, lower = 0, tags = "train"),
        base = p_dbl(default = 0.95, lower = 0, upper = 1, tags = "train"),
        ndpost = p_int(default = 1000L, lower = 1L, tags = "train"),
        nskip = p_int(default = 100L, lower = 0L, tags = "train"),
        printevery = p_int(default = 100L, lower = 0L, tags = "train"),
        keepevery = p_int(default = 1L, lower = 1L, tags = "train"),
        keeptrainfits = p_lgl(default = TRUE, tags = "train"),
        usequants = p_lgl(default = FALSE, tags = "train"),
        numcut = p_int(default = 100L, lower = 1L, tags = "train"),
        printcutoffs = p_int(default = 0, tags = "train"),
        verbose = p_lgl(default = TRUE, tags = "train"),
        keeptrees = p_lgl(default = FALSE, tags = "train"),
        keepcall = p_lgl(default = TRUE, tags = "train"),
        sampleronly = p_lgl(default = FALSE, tags = "train"),
        offset.test = p_lgl(default = FALSE, tags = "predict")
      )

      ps$values <- list(keeptrees = TRUE)

      super$initialize(
        id = "regr.bart",
        packages = c("mlr3extralearners", "dbarts"),
        feature_types = c("integer", "numeric", "factor", "ordered"),
        # TODO: add "se" to the list of predict types.
        predict_types = c("response"),
        param_set = ps,
        properties = c("weights"),
        man = "mlr3extralearners::mlr_learners_regr.bart"
      )
    }
  ),

  private = list(
    .train = function(task) {

      pars <- self$param_set$get_values(tags = "train")

      # Extact just the features from the task data.
      data <- task$data(cols = task$feature_names)

      # Convert from data.table to normal data.frame, just to be safe.
      # Dbarts expects x.train to be a dataframe.
      data.table::setDF(data)

      # This will also extract a data.table
      outcome <- task$data(cols = task$target_names)
      data.table::setDF(outcome)
      # Outcome will now be a factor vector.
      outcome <- outcome[[1]]

      if ("weights" %in% task$properties) {
        pars$weights <- task$weights$weight
      }

      # Use the mlr3misc::invoke function (it's similar to do.call())
      # y.train should either be a binary factor or have values {0, 1}
      mlr3misc::invoke(dbarts::bart,
        x.train = data, y.train = outcome,
        .args = pars
      )
    },

    .predict = function(task) {

      pars <- self$param_set$get_values(tags = "predict") # get parameters with tag "predict"

      newdata <- task$data(cols = task$feature_names) # get newdata

      # Other possible vars: offset.test, combineChains, ...
      data.table::setDF(newdata)

      # This will return a matrix of predictions, where each column is an observation
      # and each row is a sample from the posterior.
      p <- invoke(predict, self$model, newdata = newdata, .args = pars)

      # Transform predictions.
      # TODO: confirm that this is the correct element name.
      pred <- colMeans(p)

      list(response = pred)
    }
  )
)

.extralrns_dict$add("regr.bart", LearnerRegrBart)
