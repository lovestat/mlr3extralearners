% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/learner_np_dens_mixed.R
\name{mlr_learners_dens.mixed}
\alias{mlr_learners_dens.mixed}
\alias{LearnerDensMixed}
\title{Density Mixed Data Kernel Learner}
\description{
Calls \link[np:np.density]{np::npudens} from package \CRANpkg{np}.
}
\section{Dictionary}{
 This \link{Learner} can be instantiated via the
\link[mlr3misc:Dictionary]{dictionary} \link{mlr_learners} or with the associated
sugar function \code{\link[=lrn]{lrn()}}:\preformatted{mlr_learners$get("dens.mixed")
lrn("dens.mixed")
}
}

\section{Meta Information}{

\itemize{
\item Task type: \dQuote{dens}
\item Predict Types: \dQuote{pdf}
\item Feature Types: \dQuote{integer}, \dQuote{numeric}
\item Required Packages: \CRANpkg{mlr3extralearners}, \CRANpkg{np}
}
}

\section{Parameters}{
\tabular{lllll}{
   Id \tab Type \tab Default \tab Levels \tab Range \cr
   bws \tab list \tab - \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   ckertype \tab character \tab gaussian \tab gaussian, epanechnikov, uniform \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   bwscaling \tab logical \tab FALSE \tab TRUE, FALSE \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   bwmethod \tab character \tab cv.ml \tab cv.ml, cv.ls, normal-reference \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   bwtype \tab character \tab fixed \tab fixed, generalized_nn, adaptive_nn \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   bandwidth.compute \tab logical \tab FALSE \tab TRUE, FALSE \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   ckerorder \tab integer \tab 2 \tab  \tab \eqn{[2, 8]}{[2, 8]} \cr
   remin \tab logical \tab TRUE \tab TRUE, FALSE \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   itmax \tab integer \tab 10000 \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   nmulti \tab integer \tab - \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   ftol \tab numeric \tab 1.490116e-07 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   tol \tab numeric \tab 0.0001490116 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   small \tab numeric \tab 1.490116e-05 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   lbc.dir \tab numeric \tab 0.5 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   dfc.dir \tab numeric \tab 0.5 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   cfac.dir \tab list \tab 1.90983 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   initc.dir \tab numeric \tab 1 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   lbd.dir \tab numeric \tab 0.1 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   hbd.dir \tab numeric \tab 1 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   dfac.dir \tab list \tab 0.190983 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   initd.dir \tab numeric \tab 1 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   lbc.init \tab numeric \tab 0.1 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   hbc.init \tab numeric \tab 2 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   cfac.init \tab numeric \tab 0.5 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   lbd.init \tab numeric \tab 0.1 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   hbd.init \tab numeric \tab 0.9 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   dfac.init \tab numeric \tab 0.37 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   ukertype \tab character \tab - \tab aitchisonaitken, liracine \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   okertype \tab character \tab - \tab wangvanryzin, liracine \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
}
}

\examples{
if (requireNamespace("np", quietly = TRUE)) {
  learner = mlr3::lrn("dens.mixed")
  print(learner)

  # available parameters:
  learner$param_set$ids()
}
}
\references{
Li, Q. and J.S. Racine (2003),
“Nonparametric estimation of distributions with categorical and continuous data,”
Journal of Multivariate Analysis, 86, 266-292.
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
RaphaelS1
}
\section{Super classes}{
\code{\link[mlr3:Learner]{mlr3::Learner}} -> \code{\link[mlr3proba:LearnerDens]{mlr3proba::LearnerDens}} -> \code{LearnerDensMixed}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{LearnerDensMixed$new()}}
\item \href{#method-clone}{\code{LearnerDensMixed$clone()}}
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
\if{html}{\out{<div class="r">}}\preformatted{LearnerDensMixed$new()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{LearnerDensMixed$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
