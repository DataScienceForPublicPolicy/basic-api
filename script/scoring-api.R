##################
#API             #
#Housing Price   #
#Scoring Service #
##################

#Load file
#Make sure to set the working directory to the model folder
  load("//Working-directory-goes-here/Github/basic-api/model/mod.Rda")

#* Check model qualities
#* @get /modsummary
function(msg=""){
  out <- summary(mod)
  list(msg = paste0("Underlying linear regression model has a R-squared of ", 
                    round(out$r.squared,3), 
                    " with a RMSE of ", 
                    round(out$sigma,3)))
}
  

#* Score real estate based on its characteristics
#* @param bclass Building class based on NYC DOF classification
#* @param year Year that building was constructed
#* @param gsf Gross Squared Area (squared feet)
#* @param lsf Land Area (squared feet)
#* @param zip Zipcode (5 digits)
#* @get /score
function(bclass, year, gsf, lsf, zip){
  
  #Construct and format payload 
  out <- data.frame(class = bclass,
                    yearbuilt = as.numeric(year), 
                    grossarea = as.numeric(gsf), 
                    landarea = as.numeric(lsf),
                    zipcode = zip)
  
  #Score using LM
  yhat <- predict(mod, out)
  
  #Return result
  return(round(yhat))
  
}


#* Plot residuals of trained model
#* @png
#* @get /plotresids
function(){
  plot(mod)
}
