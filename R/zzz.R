#' @import data.table
#' @import paradox
#' @import mlr3misc
#' @importFrom R6 R6Class
#' @importFrom mlr3 mlr_learners LearnerClassif LearnerRegr
#' @importFrom mlr3proba TaskSurv LearnerSurv PredictionSurv
"_PACKAGE"

# nocov start
register_mlr3 = function(libname, pkgname) {
  x = utils::getFromNamespace("mlr_learners", ns = "mlr3")

  x$add("surv.coxtime", LearnerSurvCoxtime)
  x$add("surv.deepsurv", LearnerSurvDeepsurv)
  x$add("surv.deephit", LearnerSurvDeephit)
  x$add("surv.pchazard", LearnerSurvPCHazard)
  x$add("surv.loghaz", LearnerSurvLogisticHazard)
  x$add("surv.coxtime2", LearnerSurvCoxtime2)
}

pycox = torch = torchtuples = NULL
.onLoad = function(libname, pkgname) { # nolint
  register_mlr3()
  setHook(packageEvent("mlr3", "onLoad"), function(...) register_mlr3(),
    action = "append")
  pycox <<- reticulate::import("pycox", delay_load = TRUE)
  torch <<- reticulate::import("torch", delay_load = TRUE)
  torchtuples <<- reticulate::import("torchtuples", delay_load = TRUE)
}

.onUnload = function(libpath) { # nolint
  event = packageEvent("mlr3", "onLoad")
  hooks = getHook(event)
  pkgname = vapply(hooks, function(x) environment(x)$pkgname, NA_character_)
  setHook(event, hooks[pkgname != "<package>"],
    action = "replace")
}
# nocov end
