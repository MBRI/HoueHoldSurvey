# 04-HHBase.R
# Builds the base data.table for households
#
# Copyright © 2016: Majid Einian
# Licence: GPL-3

rm(list=ls())

starttime <- proc.time()
cat("\n\n================ HHBase =====================================\n")

library(yaml)
Settings <- yaml.load_file("Settings.yaml")

#library(foreign)
library(data.table)


for(year in (Settings$startyear:Settings$endyear))
{
  cat(paste0("\n------------------------------\nYear:",year,"\n"))
  
  load(file=paste0(Settings$HEISRawPath,"Y",year,"Raw.rda"))

  #  if(year %in% 87:93)
  
  print(names(Tables))
  
}

endtime <- proc.time()

cat("\n\n============================\nIt took ")
cat(endtime-starttime)

