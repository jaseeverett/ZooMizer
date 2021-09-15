## Run the ZooMSS component of the ZooMizer model.
##
##
## Updated Monday 5th of July, 2021

library(mizer)
library(tidyverse)
library(assertthat)

#job specifics
Groups <- read.csv("data/TestGroups_mizer.csv") # Load in functional group information

jobname <- '20210705_grid' #job name used on queue

ID <- 600
ID_char <- sprintf("%04d",ID)

# Choose environmental data to use
enviro <- readRDS("data/enviro_grid20210705.RDS")[ID,]
enviro$tmax <- 100

## Many many functions are repeated between "uncoupledmodel.R" and "ZooMizerResourceFunctions.R". 
# Calling "ZooMizerResourceFunctions.R" last should make these ones the default but this is still 
# very very bad practice. Need to sort this out urgently......
source("uncoupledmodel.R")
source("ZooMizerResourceFunctions.R") 

environment(new_project_simple) <- asNamespace('mizer') 
assignInNamespace("project_simple", new_project_simple, ns = "mizer")

resource = "phyto_fixed"
zoomss_pf <- fZooMizer_run(groups = Groups, input = enviro, resource = resource)

resource = "resource_semichemostat"
zoomss_sc <- fZooMizer_run(groups = Groups, input = enviro, resource = resource)

resource = "resource_constant"
zoomss_ct <- fZooMizer_run(groups = Groups, input = enviro, resource = resource)


identical(zoomss_ct@n, zoomss_ct@n) # All outputs are identical irrespective of resource
identical(zoomss_ct@n, zoomss_pf@n) # All outputs are identical irrespective of resource
identical(zoomss_ct@n, zoomss_sc@n) # All outputs are identical irrespective of resource

# Check resource spectrum is correcly specified
assert_that(zoomss_pf@params@resource_dynamics == "phyto_fixed")
assert_that(zoomss_sc@params@resource_dynamics == "resource_semichemostat")
assert_that(zoomss_ct@params@resource_dynamics == "resource_constant")

# Plot params
plot(zoomss_pf@params) # Identical plots
plot(zoomss_sc@params) # Identical plots
plot(zoomss_ct@params) # Identical plots

# Plot output
plot(zoomss_pf) # Identical plots
plot(zoomss_sc) # Identical plots
plot(zoomss_ct) # Identical plots



