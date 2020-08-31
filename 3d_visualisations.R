# ------------------------------------------------------------------------------
# Author:  SLC
# Date:    2020-08-11
# Summary: This Script should import Excel-data and visualise them in a 3d plot
#           - firt try will be using the package plotly. Let's see what happens ;)
# ------------------------------------------------------------------------------
imsbasics::clc()
# Set Working Directory, load functions,
my_wd <- paste0(getwd(), "/data/")
source("functions.R")

# ------------------------- Import Data ----------------------------------------
# # Define filenames to load from working-directory
# filenames <- paste0(my_wd, "Szenario", seq(1,4), ".xlsx")
#
# # Define columns to import from excel-sheets
# # column 1 = "year"
# # column EV =  5*26+22 = Landfill management Region A."Self-sufficiency excavation material Region A"
# # column JZ = 11*26    = Primary and secondary market Region A."Regional self-sufficiency Region A"
# # column QF = 17*26+6  = Settlement development.Annual Recycling quota
# cols <- sort(c(1, 5*26+22, 11*26, 17*26+6))
# colnames <- c("exvac_material", "self_sufficiency", "recyc_quota")
#
#
# # create empty data.frame
# df <- data.frame(scenario = numeric(),
#                  policy = numeric(),
#                  year = numeric(),
#                  a = numeric(), b = numeric(), c = numeric(),
#                  stringsAsFactors = FALSE)
# names(df)[c(4:6)] <- colnames
#
# # fill data.frame with data from 4 Excel sheets
# for (i in seq(1,4)) {
#   cat("\n Create Szenario", i)
#   for (j in seq(1,9)) {
#     cat(" \n --> import Sheet ", j)
#     dat <- openxlsx::read.xlsx(xlsxFile = filenames[i], sheet = j, cols = cols)
#     names(dat)[2:4] <- colnames
#     dat <- cbind(scenario = i, policy = j, dat)
#     df <- rbind(df, dat)
#   }
#   rm(dat)
# }
# # Add a last column "x" and save data.frame
# df <- cbind(x =  as.numeric(paste0(df$scenario,".", df$policy)), df)
# imsbasics::save_rdata(df, "df", my_wd, force = T)

# -------------------------------- Load Data -----------------------------------
df <- imsbasics::load_rdata("df", my_wd)

# ---------------------------------- Plots -------------------------------------

plot3d(df, z_column = "exvac_material")
plot3d(df, z_column = "self_sufficiency", stretch_x = 4)
plot3d(df, z_column = "self_sufficiency", z_lim = c(50,90))


plot3d(df, z_column = "self_sufficiency", scenarios = c(3), stretch_x = 0.5)
plot3d(df, z_column = "recyc_quota", policies = c(6,7,8,9))
plot3d(df, z_column = "recyc_quota", policies = seq(1,5))
plot3d(df, z_column = "exvac_material", scenarios = c(1,2,4), policies = c(4,5,6))
