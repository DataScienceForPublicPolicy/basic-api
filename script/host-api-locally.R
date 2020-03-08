######################
# Host API End Point #
######################

#Set Directory with API code
  setwd("/Users/jeff/Documents/Github/basic-api/script")

#Load Plumber package
  pacman::p_load(plumber)

#Load Plumber code
  r <- plumb("scoring-api.R") 
  
#API will available at http://localhost:8000
  r$run(port=8000)
