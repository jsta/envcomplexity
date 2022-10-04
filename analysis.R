library(dplyr)

# --- trying pre-cleaned JOSS data
# https://github.com/openjournals/joss-analytics

library(desc)
library(gh)

papers <- readRDS(gzcon(url(
  "https://github.com/openjournals/joss-analytics/blob/gh-pages/joss_submission_analytics.rds?raw=true")))
# head(dplyr::select(papers, starts_with("repo")))

dt <- dplyr::filter(papers, repo_language == "R")

get_deps <- function(i){
    download.file(paste0(dt$repo_url[i], "/raw/master/DESCRIPTION"), "DESCRIPTION")
    d <- desc::desc()
    deps <- d$get_deps()
    deps$pkg_name <- strsplit(dt$api_title[i], "\\:")[[1]][1]
    deps
}

get_deps(2)


# --- trying pure Zenodo
# library(zen4R)
# dt <- read.csv("data/asclepias_broker_citations_201901_processed.csv")
# zen <- ZenodoManager$new()
# zen$getRecordByDOI("10.5281/zenodo.12158")
# test <- zen$getRecordByConceptDOI("10.5281/zenodo.592762")
