#Loading package
library(R0)
library(XML)

# Assign your URL to `url`
url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"

# Read the HTML table
df <- read.csv(url, header = TRUE)
col <- ncol(df)

mGT<-generation.time("gamma", c(2.45, 1.38))

#remove first few columns
scrap <- 6

#get province
which(df[,1]=="Quebec",arr.ind=FALSE)
# get country
which(df[,2]=="Russia",arr.ind=FALSE)

# get all data for 1 row
data <- df[188, scrap:col]
ndata <- as.numeric(data)
#calculate R0 for last 2 weeks

est.R0.ML(ndata, mGT, begin=(scrap+15), end=(col-scrap+1), range=c(0.01,50))
est.R0.ML(ndata, mGT, begin=(col-60-scrap+1), end=(col-scrap+1), range=c(0.01,50))

est.R0.EG(ndata, mGT, t = NULL, begin = NULL, end = NULL, date.first.obs = NULL,
time.step = 1, reg.met = "poisson", checked = FALSE)


est.R0.TD(ndata, mGT, begin=20, end=100, nsim=100)

# est.R0.SB(ndata, t = 20,  mGT, begin=NULL, end=NULL, date.first.obs = NULL,
# time.step = 1, force.prior=FALSE, checked = FALSE)
#ncol(df)
