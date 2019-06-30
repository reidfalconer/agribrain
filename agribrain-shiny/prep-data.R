#devtools::install_github("poissonconsulting/poisspatial") 
library(rtide)
library(poisspatial)
library(dplyr)
sites <- rtide::harmonics$Station %>%
ps_longlat_to_sfc() %>%
ps_activate_sfc() %>%
select(Station, TZ) %>%
ps_sfc_to_coords()
sites <- sites[1, ]
censor_1 <- c("Aberdeen, Grays Harbor, Washington", "UTC", as.numeric(0.468155), as.numeric(32.611484))
censor_2 <- c("Agnes Cove, Aialik Peninsula, Alaska", "UTC", as.numeric(0.468064), as.numeric(32.610705))
censor_3 <- c("Aguadilla, Crashboat Beach, Puerto Rico", "UTC", as.numeric(0.467869), as.numeric(32.610013))
sites <- rbind(sites, censor_1, censor_2, censor_3)
sites <- sites[1:4, ]
sites$X <- as.numeric(sites$X)
sites$Y <- as.numeric(sites$Y)
sites <- sites[2:4, ]
Names <- c("CENSOR 3", "CENSOR 2", "CENSOR 1")
sites <- cbind(sites, Names)
saveRDS(sites, 'input/sites.rds')
