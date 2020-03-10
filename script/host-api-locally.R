######################
# Host API End Point #
######################

#Set Directory with API code
#Make sure to set the working directory to the script folder of your local version of the repo
  setwd("//Working-directory-goes-here/Github/basic-api/script")

#Load Plumber package
  pacman::p_load(plumber)

#Load Plumber code
  r <- plumb("scoring-api.R") 
  
#API will available at http://localhost:8000
  r$run(port=8000)
