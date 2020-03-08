#########################################
# Train a model for a scoring service   #
#########################################


#Set Directory with API code
  setwd("/Users/jeff/Documents/Github/basic-api")
  
#Load
  pacman::p_load(readr, ranger)

#Build model
  train <- read_csv("data/home_sales_bk.csv")

#Clean up
  train <- train[train$price > 10000, ]
  train <- train[train$grossarea > 0, ]
  train <- train[!is.na(train$price),]
  train <- train[!is.na(train$yearbuilt),]

#Remove outliers
  train <- train[abs(scale(train$price))<2,]
  
  
#Regression
  mod <- lm(price ~ yearbuilt +  factor(class)*grossarea + factor(zipcode) + landarea, 
                data = train)
  
#Outputs
  outdata <- train[, c("price", "grossarea", "class")]
  save(mod, outdata, file = "model/mod.Rda")
  