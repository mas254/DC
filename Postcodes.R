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
colnames(pop2)[1:7] <- c("LSOA11NM", "LSOA11CD", "Males", "Males (%)", "Females", "Females (%)",
                         "Density (number of persons per hectare)")

pop3 <- subset(pop2, select = -2)

rm(pop, pop2)

##### Merge pop #####
mergepop <- pop2 %>%
  full_join(merge, by = "LSOA11NM")

# Wouldn't actually want these merged, need to keep LSOA and Parish separate

rm(mergepop)

##### Unemployed #####
un <- fread('Files/unemployedlsoa.csv')
colnames(un)[1:6] <- c("LSOA11NM", "LSOA11CD", "Households", "Males (%)", "Households with no adults employed",
                       "Households with no adults employed (%)")
un <- subset(un, select = -c(2, 4, 5))

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

##### Fixing issues #####
mean(age$`All usual residents`[age$LSOA11NM == 'Exeter'])
exeage <- fread('Files/exeterage.csv')
unique(LSOA$LAD11NM)
allage <- fread('Files/allage.csv')
colnames(allage)[1:16] <- c("LSOA11NM", "DEL", "Population", "DEL2", "DEL3","Age 65-74 (%)", "DEL4", "Age 75-84 (%)",
                            "DEL5", "Age 85-89 (%)", "DEL6", "Age 90+ (%)", "Mean Age", "DEL7", "Median Age", "DEL8")
Age <- subset(allage, select = -c(2, 4, 5, 7, 9, 11, 14, 16))                            
Agelsoa <- LSOA %>%
  full_join(Age, by = 'LSOA11NM')

rm(age, Agelsoa, exeage, allage)
write.csv(Age, 'Files/CompleteAge.csv')

mean(Age$Population)
mean(Agelsoa$Population)

employment <- fread('Files/Employment2.csv')
colnames(employment)[1:6] <- c("LSOA11NM", "DEL", "Households", "DEL2", "DEL3", "No adults in employment in household (%)")
Employment <- subset(employment, select = -c(2, 4, 5))
rm(employment)
write.csv(Employment, 'Files/CompleteEmployment.csv')

# Only 452 obs. for employment check at end (rest 457 so far) - sorted

rm(draft, draft2, merge4, parishes, un)

pop <- fread('Files/Population.csv')
colnames(pop)[1:10] <- c("LSOA11NM", "DEL", "DEL2", "DEL3", "Males", "Males (%)", "Females", "Females (%)",
                         "Density (number of persons per hectare)", "DEL4")
Population <- select(pop, -c(2, 3, 4, 10))
rm(pop, pop3)

write.csv(Population, 'Files/CompletePopulation.csv')

Employment <- employment
rm(employment)

rm(exeterdata)

cars <- fread('Files/Cars.csv')
colnames(cars)[1:16] <- c("LSOA11NM", "DEL", "DEL2", "DEL3", "DEL4", "No cars or vans in household (%)", "DEL9",
                            "1 car or van in household (%)", "DEL5", "2 cars or vans in household (%)", "DEL6",
                            "3 cars or vnas in household (%)", "DEL7", "4 or more cars or vans in household (%)",
                            "Total cars or vans in area", "DEL8")
Cars <- select(cars, -c(2, 3, 4, 5, 7, 9, 11, 13, 16))
rm(cars)
colnames(Cars)[5] <- "3 cars or vans in household (%)"

Merge <- LSOA %>%
  full_join(Age, by = 'LSOA11NM') %>%
  full_join(Cars, by = 'LSOA11NM') %>%
  full_join(Employment, by = 'LSOA11NM') %>%
  full_join(Population, by = 'LSOA11NM') %>%
  full_join(Religion, by = 'LSOA11NM')

# Rearrange columns to make best sense

write.csv(Merge, 'Files/FirstMerge.csv')

##### Adding more variables #####

# Variables: Age, Cars, Employment, Population, Religion, Ethnic group, hours works (male/female split),
# economic activity by sex, qualifications/students/students employed/unemployed/inactive, Household type,
# industry by sex, occupation by sex Tenure, Household size and central heating, Health, Care home (y/n), NS Sec.

# Add deprivation data.

Religion <- fread('Files/Religion.csv')

Draft <- Merge[c(1:6, 25, 21:24, 7:12, 19:20, 13:18, 34, 26:33, 35)]

write.csv(Draft, 'Files/Draft.csv')

Ethnicity <- fread('Files/EthnicityBasic.csv')

Draft2 <- Draft %>%
  full_join(Ethnicity, by = 'LSOA11NM')

Hours <- fread('Files/HoursWorked.csv')

Draft2 <- Draft2 %>%
  full_join(Hours, by = 'LSOA11NM')

EAM <- fread('Files/EconomicAMale.csv')
EAF <- fread('Files/EF.csv')

EA <- EAM %>%
  full_join(EAF, by = 'LSOA11NM')

rm(EAM, EAF)

Draft2 <- Draft2 %>%
  full_join(EA, by = 'LSOA11NM')
  full_join(EA, by = 'LSOA11NM')

write.csv(Draft2, 'Files/Draft2.csv')

accom <- fread('Files/accom.csv')
rm(accom)
Accom <- fread('Files/accom.csv')

Qualif <- fread('Files/Qualif.csv')                

Jobs <- fread('Files/Jobs.csv')

Industry <- fread('Files/Industry.csv')

Tenure <- fread('Files/Tenure.csv')

Beds <- fread('Files/Bedrooms.csv')

Health <- fread('Files/HealthCare.csv')
rm(health)

CareHomes <- fread('Files/CareHome.csv')

NsSec <- fread('Files/NsSec.csv')

Merge <- LSOA %>%
  full_join(Age, by = 'LSOA11NM') %>%
  full_join(Cars, by = 'LSOA11NM') %>%
  full_join(Employment, by = 'LSOA11NM') %>%
  full_join(Population, by = 'LSOA11NM') %>%
  full_join(Religion, by = 'LSOA11NM') %>%
  full_join(Ethnicity, by = 'LSOA11NM') %>%
  full_join(Hours, by = 'LSOA11NM') %>%
  full_join(EA, by = 'LSOA11NM') %>%
  full_join(Accom, by = 'LSOA11NM') %>%
  full_join(Qualif, by = 'LSOA11NM') %>%
  full_join(Jobs, by = 'LSOA11NM') %>%
  full_join(Industry, by = 'LSOA11NM') %>%
  full_join(Tenure, by = 'LSOA11NM') %>%
  full_join(Beds, by = 'LSOA11NM') %>%
  full_join(Health, by = 'LSOA11NM') %>%
  full_join(CareHomes, by = 'LSOA11NM') %>%
  full_join(NsSec, by = 'LSOA11NM')

write.csv(Merge, 'Files/CompleteMerge.csv')

# Reorder this file next step, then add other data

##### Adding Deprivation Data #####

rm(depEX)

# East Devon

DepED <- fread('Files/DepED.csv')
rm(depED)
DeprED <- subset(DepED, DepED$`Postcode Status` == 'Live')
rm(DepED)
rm(deprED)
write.csv(DeprED, 'Files/ED.csv')

# Mid Devon

DepMD <- fread('Files/DepMD.csv')
DeprMD <- subset(DepMD, DepMD$`Postcode Status` == 'Live')
rm(DepMD)
write.csv(DeprMD, 'Files/MD.csv')

# North Devon

DepND <- fread('Files/DepND.csv')
DeprND <- subset(DepND, DepND$`Postcode Status` == 'Live')
rm(DepND)
write.csv(DeprND, 'Files/ND.csv')

# West Devon

DepWD <- fread('Files/DepWD.csv')
DeprWD <- subset(DepWD, DepWD$`Postcode Status` == 'Live')
rm(DepWD)
write.csv(DeprWD, 'Files/WD.csv')

# Exeter

DepEX <- fread('Files/DepEX.csv')
DeprEX <- subset(DepEX, DepEX$`Postcode Status` == 'Live')
rm(DepEX)
write.csv(DeprEX, 'Files/EX.csv')

# South Hams

DepSH <- fread('Files/DepSH.csv')
DeprSH <- subset(DepSH, DepSH$`Postcode Status` == 'Live')
rm(DepSH)
write.csv(DeprSH, 'Files/SH.csv')

# Teignbridge

DepTE <- fread('Files/DepTE.csv')
DeprTE <- subset(DepTE, DepTE$`Postcode Status` == 'Live')
rm(DepTE)
write.csv(DeprTE, 'Files/TE.csv')

# Torridge

DepTO <- fread('Files/DepTO.csv')
DeprTO <- subset(DepTO, DepTO$`Postcode Status` == 'Live')
rm(DepTO)
write.csv(DeprTO, 'Files/TO.csv')

# This is wrong
colnames(LSOA)[3] <- "LSOA Code"

IoD <- LSOA %>%
  full_join(DeprED, by = 'LSOA Code') %>%
  full_join(DeprMD, by = 'LSOA Code') %>%
  full_join(DeprND, by = 'LSOA Code') %>%
  full_join(DeprWD, by = 'LSOA Code') %>%
  full_join(DeprEX, by = 'LSOA Code') %>%
  full_join(DeprSH, by = 'LSOA Code') %>%
  full_join(DeprTE, by = 'LSOA Code') %>%
  full_join(DeprTO, by = 'LSOA Code')
# Loading in

ID <- fread('Files/ED.csv')

# Remove unnecessary variables from ID, join with Merge

colnames(ID)

Ind <- ID[c(2, 4:29)]

colnames(Ind)[1] <- "PCD8"

head(Combd)

rm(ID)
rm(IoD)

Combd <- subset(Merge, select = c(1:6, 21:25, 7:12, 36:45, 26:35, 230:244, 110:122, 46:58, 59:92, 123:209, 259:303, 19, 13:18, 20, 210:218,
                227:229, 219:226, 93:109, 245:258))

colnames(Combd)

FullData <- Combd %>%
  full_join(Ind, by = 'PCD8')

test <- subset(FullData, select = 1:5)
View(test)
is.na(test$PCD8)

test2 <- subset(Merge, select = 1:5)
View(test2)

test3 <- subset(Ind, select = 1:5)
View(test3)

test4 <- subset(Combd, select = 1:5)
View(test4)

test5 <- test3 %>%
  full_join(test4, by = 'PCD8')
View(test5)

unique(Ind$PCD8)
unique(Combd$PCD8)

# We have two datasets - Comb for the census data and Ind for the indicies of multiple deprivation data

# save.image("Files/AllLoaded.RData")
rm(list = ls())
load("Files/AllLoaded.RData")

write.csv(Ind, "Files/IofMDFull.csv")
write.csv(Combd, "Files/CensusFull.csv")

colnames(Ind)
colnames(Combd)

# Shiny next!