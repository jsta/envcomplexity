library(dplyr)

# --- trying pre-cleaned JOSS data
# https://github.com/openjournals/joss-analytics

library(desc)
library(gh)

joss_rds <- "data/joss_R.rds"
# unlink(joss_rds)
if (!file.exists(joss_rds)) {
  papers <- readRDS(gzcon(url(
    "https://github.com/openjournals/joss-analytics/blob/gh-pages/joss_submission_analytics.rds?raw=true")))
  # head(dplyr::select(papers, starts_with("repo")))
  dt <- dplyr::filter(papers, repo_language == "R")
  dt <- dplyr::filter(papers,
    repo_url != "https://github.com/hansenjohnson/WhaleMap")
  saveRDS(dt, "data/joss_R.rds")
}

get_desc <- function(i, dt, path = "DESCRIPTION") {
    print(i)
    out_path <- paste0("data/", "DESCRIPTION", "_", as.character(i))
    if(!file.exists(out_path)) {
      tryCatch({
        tryCatch({
          download.file(paste0(dt$repo_url[i], "/raw/master/DESCRIPTION"), path)
          Sys.sleep(runif(1, max = 3))
          file.copy(path, out_path)
          }, error = function(e) {
              download.file(paste0(dt$repo_url[i], "/raw/main/DESCRIPTION"), path)
              Sys.sleep(runif(1, max = 3))
              file.copy(path, out_path)
          })
        }, error = function(e) {
          print(e)
      })
    }
}

get_deps <- function(i) {
    print(i)
    path <- paste0("data/", "DESCRIPTION", "_", as.character(i))
    if(!file.exists(path)){
      return(NA)
    }
    d <- desc::desc(file = path)
    deps <- d$get_deps()
    deps$pkg_name <- strsplit(dt$api_title[i], "\\:")[[1]][1]
    deps <- dplyr::filter(deps, !grepl("R", package))
    deps
}

dt <- readRDS(joss_rds)
lapply(seq_len(length(dt)), function(i) get_desc(i, dt))
deps <- lapply(seq_len(length(dt)), function(i) get_deps(i))

unlist(lapply(deps, function(x) nrow(x)))

# --- trying pure Zenodo
# library(zen4R)
# dt <- read.csv("data/asclepias_broker_citations_201901_processed.csv")
# zen <- ZenodoManager$new()
# zen$getRecordByDOI("10.5281/zenodo.12158")
# test <- zen$getRecordByConceptDOI("10.5281/zenodo.592762")
