library(dplyr)
library(zen4R)

dt <- read.csv("data/asclepias_broker_citations_201901_processed.csv")

zen <- ZenodoManager$new()
# zen$getRecordByDOI("10.5281/zenodo.12158")
test <- zen$getRecordByConceptDOI("10.5281/zenodo.592762")