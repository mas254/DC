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

parish <- fread("Files/pcd11_par11_wd11_lad11_ew_lu.csv")
unique(parish$par11nm)
