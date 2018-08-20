library(tidyverse)
library(data.table)
lsoa <- fread("Files/PCD11_OA11_LSOA11_MSOA11_LAD11_EW_LU_aligned_v2.csv")
unique(lsoa$LAD11NM)
# "East Devon"; "Exeter"; "Mid Devon"; "North Devon"; "South Hams"; "Teignbridge"; "Torridge"; "West Devon"
# 128:135
lsoa2 <- fread("Files/PCD11_OA11_LSOA11_MSOA11_LAD11_EW_LU_aligned_v2.csv",
               select = c("PCD7", "PCD8", "LSOA11CD", "LSOA11NM", "LAD11NM"))

lsoa$LAD11NM[555027]
lsoa$LAD11NM[529255]
test <- data.frame(PCD7 = lsoa2$PCD7[529255:555027], PCD8 = lsoa2$PCD8[529255:555027],
                   LSOA11CD = lsoa2$LSOA11CD[529255:555027], LSOA11NM = lsoa2$LSOA11NM[529255:555027],
                   LAD11NM = lsoa2$LAD11NM[529255:555027])
LSOA <- test

test <- lsoa2[which(lsoa2$LAD11NM == 'East Devon' | lsoa2$LAD11NM == 'Exeter' |
              lsoa2$LAD11NM == 'Mid Devon' | lsoa2$LAD11NM == 'North Devon' |
              lsoa2$LAD11NM == 'South Hams' | lsoa2$LAD11NM == 'Teignbridge' |
              lsoa2$LAD11NM == 'Torridge' | lsoa2$LAD11NM == 'West Devon')]

LSOA <- test

parish <- fread("Files/pcd11_par11_wd11_lad11_ew_lu.csv")
unique(parish$par11nm)
unique(parish$lad11nm)
which(parish$lad11nm == "East Devon")
parish$lad11nm[342910:394057]
376232 + 4229
which(parish$lad11nm == "Exeter")
getOption("max.print")
options(max.print = 6000)
parish$lad11nm[1134473]

parish$lad11nm == 'East Devon'
newdata <- mydata[ which(mydata$gender=='F'
                         & mydata$age > 65), ]

test <- parish[which(parish$lad11nm == 'East Devon' | parish$lad11nm == 'Exeter' |
                       parish$lad11nm == 'Mid Devon' | parish$lad11nm == 'North Devon' |
                       parish$lad11nm == 'South Hams' | parish$lad11nm == 'Teignbridge' |
                       parish$lad11nm == 'Torridge' | parish$lad11nm == 'West Devon')]
parishes <- test[c(-3)]
parishes <- subset(test, select = -c(3, 6:9, 12))


eastdevon <- fread('Files/deprivation-data.csv')
which(LSOA$PCD7 == 'EX12 4AB')
unique(LSOA$LSOA11NM)
rm(parish, lsoa2, eastdevon)

colnames(LSOA)[2] <- "pcd8"

merge <- LSOA %>%
  full_join(parishes, by = "pcd8")
