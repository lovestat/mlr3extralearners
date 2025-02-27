% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/learner_partykit_regr_mob.R
\name{mlr_learners_regr.mob}
\alias{mlr_learners_regr.mob}
\alias{LearnerRegrMob}
\title{Regression Model-based Recursive Partitioning Learner}
\description{
Calls \link[partykit:mob]{partykit::mob} from package \CRANpkg{partykit}.
}
\section{Dictionary}{
 This \link{Learner} can be instantiated via the
\link[mlr3misc:Dictionary]{dictionary} \link{mlr_learners} or with the associated
sugar function \code{\link[=lrn]{lrn()}}:\preformatted{mlr_learners$get("regr.mob")
lrn("regr.mob")
}
}

\section{Meta Information}{

\itemize{
\item Task type: \dQuote{regr}
\item Predict Types: \dQuote{response}, \dQuote{se}
\item Feature Types: \dQuote{logical}, \dQuote{integer}, \dQuote{numeric}, \dQuote{character}, \dQuote{factor}, \dQuote{ordered}
\item Required Packages: \CRANpkg{mlr3extralearners}, \CRANpkg{partykit}, \CRANpkg{sandwich}, \CRANpkg{coin}
}
}

\section{Parameters}{
\tabular{lllll}{
   Id \tab Type \tab Default \tab Levels \tab Range \cr
   rhs \tab list \tab - \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   fit \tab list \tab - \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   offset \tab list \tab - \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   cluster \tab list \tab - \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   alpha \tab numeric \tab 0.05 \tab  \tab \eqn{[0, 1]}{[0, 1]} \cr
   bonferroni \tab logical \tab TRUE \tab TRUE, FALSE \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   minsize \tab integer \tab - \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   minsplit \tab integer \tab - \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   minbucket \tab integer \tab - \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   maxdepth \tab integer \tab Inf \tab  \tab \eqn{[0, \infty)}{[0, Inf)} \cr
   mtry \tab integer \tab Inf \tab  \tab \eqn{[0, \infty)}{[0, Inf)} \cr
   trim \tab numeric \tab 0.1 \tab  \tab \eqn{[0, \infty)}{[0, Inf)} \cr
   breakties \tab logical \tab FALSE \tab TRUE, FALSE \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   parm \tab list \tab - \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   dfsplit \tab integer \tab - \tab  \tab \eqn{[0, \infty)}{[0, Inf)} \cr
   prune \tab list \tab - \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   restart \tab logical \tab TRUE \tab TRUE, FALSE \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   verbose \tab logical \tab FALSE \tab TRUE, FALSE \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   maxvar \tab integer \tab - \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   caseweights \tab logical \tab TRUE \tab TRUE, FALSE \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   ytype \tab character \tab vector \tab vector, matrix, data.frame \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   xtype \tab character \tab matrix \tab vector, matrix, data.frame \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   terminal \tab list \tab object \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   inner \tab list \tab object \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   model \tab logical \tab TRUE \tab TRUE, FALSE \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   numsplit \tab character \tab left \tab left, center \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   catsplit \tab character \tab binary \tab binary, multiway \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   vcov \tab character \tab opg \tab opg, info, sandwich \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   ordinal \tab character \tab chisq \tab chisq, max, L2 \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   nrep \tab integer \tab 10000 \tab  \tab \eqn{[0, \infty)}{[0, Inf)} \cr
   applyfun \tab list \tab - \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   cores \tab integer \tab NULL \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   additional \tab list \tab - \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   predict_fun \tab list \tab - \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
}
}

\examples{
if (requireNamespace("partykit", quietly = TRUE) && requireNamespace("sandwich", quietly = TRUE) && requireNamespace("coin", quietly = TRUE)) {
  learner = mlr3::lrn("regr.mob")
  print(learner)

  # available parameters:
  learner$param_set$ids()
}
}
\references{
Hothorn T, Zeileis A (2015).
“partykit: A Modular Toolkit for Recursive Partytioning in R.”
Journal of Machine Learning Research, 16(118), 3905-3909.
\url{http://jmlr.org/papers/v16/hothorn15a.html}

Hothorn T, Hornik K, Zeileis A (2006).
“Unbiased Recursive Partitioning: A Conditional Inference Framework.”
Journal of Computational and Graphical Statistics, 15(3), 651–674.
\doi{10.1198/106186006x133933}

Zeileis A, Hothorn T, Hornik K (2008).
“Model-Based Recursive Partitioning.”
Journal of Computational and Graphical Statistics, 17(2), 492–514.
\doi{10.1198/106186008X319331}
}
\seealso{
\itemize{
\item \link[mlr3misc:Dictionary]{Dictionary} of \link[mlr3:Learner]{Learners}: \link[mlr3:mlr_learners]{mlr3::mlr_learners}.
\item \code{as.data.table(mlr_learners)} for a table of available \link[=Learner]{Learners} in the running session (depending on the loaded packages).
\item Chapter in the \href{https://mlr3book.mlr-org.com/}{mlr3book}: \url{https://mlr3book.mlr-org.com/basics.html#learners}
\item \CRANpkg{mlr3learners} for a selection of recommended learners.
\item \CRANpkg{mlr3cluster} for unsupervised clustering learners.
\item \CRANpkg{mlr3pipelines} to combine learners with pre- and postprocessing steps.
\item \CRANpkg{mlr3tuning} for tuning of hyperparameters, \CRANpkg{mlr3tuningspaces} for established default tuning spaces.
}
}
\author{
sumny
}
\section{Super classes}{
\code{\link[mlr3:Learner]{mlr3::Learner}} -> \code{\link[mlr3:LearnerRegr]{mlr3::LearnerRegr}} -> \code{LearnerRegrMob}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{LearnerRegrMob$new()}}
\item \href{#method-clone}{\code{LearnerRegrMob$clone()}}
}
}
\if{html}{
\out{<details ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="base_learner">}\href{../../mlr3/html/Learner.html#method-base_learner}{\code{mlr3::Learner$base_learner()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="format">}\href{../../mlr3/html/Learner.html#method-format}{\code{mlr3::Learner$format()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="help">}\href{../../mlr3/html/Learner.html#method-help}{\code{mlr3::Learner$help()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="predict">}\href{../../mlr3/html/Learner.html#method-predict}{\code{mlr3::Learner$predict()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="predict_newdata">}\href{../../mlr3/html/Learner.html#method-predict_newdata}{\code{mlr3::Learner$predict_newdata()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="print">}\href{../../mlr3/html/Learner.html#method-print}{\code{mlr3::Learner$print()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="reset">}\href{../../mlr3/html/Learner.html#method-reset}{\code{mlr3::Learner$reset()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="train">}\href{../../mlr3/html/Learner.html#method-train}{\code{mlr3::Learner$train()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
Creates a new instance of this \link[R6:R6Class]{R6} class.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{LearnerRegrMob$new()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{LearnerRegrMob$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
