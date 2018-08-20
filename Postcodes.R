##### Prep #####

library(tidyverse)
library(data.table)

getOption("max.print")
options(max.print = 6000)

##### lsoa #####

lsoa <- fread("Files/PCD11_OA11_LSOA11_MSOA11_LAD11_EW_LU_aligned_v2.csv")

unique(lsoa$LAD11NM)
# "East Devon"; "Exeter"; "Mid Devon"; "North Devon"; "South Hams"; "Teignbridge"; "Torridge"; "West Devon"

lsoa2 <- fread("Files/PCD11_OA11_LSOA11_MSOA11_LAD11_EW_LU_aligned_v2.csv",
               select = c("PCD7", "PCD8", "LSOA11CD", "LSOA11NM", "LAD11NM"))

test <- lsoa2[which(lsoa2$LAD11NM == 'East Devon' | lsoa2$LAD11NM == 'Exeter' |
                      lsoa2$LAD11NM == 'Mid Devon' | lsoa2$LAD11NM == 'North Devon' |
                      lsoa2$LAD11NM == 'South Hams' | lsoa2$LAD11NM == 'Teignbridge' |
                      lsoa2$LAD11NM == 'Torridge' | lsoa2$LAD11NM == 'West Devon')]
LSOA <- test

SOA

##### Parish #####

parish <- fread("Files/pcd11_par11_wd11_lad11_ew_lu.csv")
unique(parish$par11nm)
unique(parish$lad11nm)

test <- parish[which(parish$lad11nm == 'East Devon' | parish$lad11nm == 'Exeter' |
                       parish$lad11nm == 'Mid Devon' | parish$lad11nm == 'North Devon' |
                       parish$lad11nm == 'South Hams' | parish$lad11nm == 'Teignbridge' |
                       parish$lad11nm == 'Torridge' | parish$lad11nm == 'West Devon')]
parishes <- subset(test, select = -c(3, 6:9, 12))

which(LSOA$PCD7 == 'EX12 4AB')
unique(LSOA$LSOA11NM)
colnames(LSOA)[2] <- "PCD8"
colnames(parishes)[2] <- "PCD8"

##### Merge #####

merge <- LSOA %>%
  full_join(parishes, by = "PCD8")

rm(merge)
##### LSOA & Parish pop stats #####

pop <- fread('Files/poplsoa.csv')
pop2 <- subset(pop, select = -c(3, 9))
colnames(pop2)[1:7] <- c("LSOA11NM", "LSOA11CD", "Males", "Males (%)", "Females", "Females (%)", "Density (number of persons per hectare)")

pop3 <- subset(pop2, select = -2)

rm(pop, pop2)

##### Merge pop #####
mergepop <- pop2 %>%
  full_join(merge, by = "LSOA11NM")

# Wouldn't actually want these merged, need to keep LSOA and Parish separate

rm(mergepop)

##### Unemployed #####
un <- fread('Files/unemployedlsoa.csv')
colnames(un)[1:6] <- c("LSOA11NM", "LSOA11CD", "Households", "Males (%)", "Households with no adults employed", "Households with no adults employed (%)")
un <- subset(un, select = -c(2, 3, 4))

##### Merge lsoa #####
merge3 <- LSOA %>%
  full_join(age, by = "LSOA11NM")
merge3 <- merge3 %>%
  full_join(un, by = "LSOA11NM")
merge3 <- merge3 %>%
  full_join(health, by = "LSOA11NM")

merge4 <- LSOA %>%
  full_join(pop3, by = "LSOA11NM") %>% 
  full_join(un, by = "LSOA11NM") %>% 
  full_join(age, by = "LSOA11NM") %>%
  full_join(health, by = "LSOA11NM")

rm(merge3)
##### Health #####
health <- fread('Files/healthlsoa.csv')

##### Age #####
age <- fread('Files/agelsoa.csv', header = TRUE)

##### Draft #####
draft <- merge4[c(1:5, 20, 6:9, 14:19, 10:12, 21:32)]

draft2 <- draft %>%
  full_join(deprED, by = "LSOA11CD")

# It does not work to simply merge this as before, creates a new column for the same variables
full_join(depEX, by = "LSOA11CD")

##### Deprivation #####
# East Devon

depED <- fread('Files/deprivation-data.csv')
deprED <- subset(depED, depED$`Postcode Status` == 'Live')
deprED <- subset(deprED, select = -c(2, 4))
colnames(deprED)[2] <- "LSOA11CD"

# Exeter
depEX <- fread('Files/ExeterDeprivation.csv')
depEX <- subset(depEX, depEX$`Postcode Status` == 'Live')
depEX <- subset(depEX, select = -c(2, 4))
colnames(depEX)[2] <- "LSOA11CD"

# Working out the merging issue above
unique(draft2$LAD11NM)

exeterdata <- subset(draft2, draft2$LAD11NM == 'Exeter')

# Saving work
write.csv(draft2, "myData/dataset.csv")