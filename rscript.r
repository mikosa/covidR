#Loading package
library(R0)
library(XML)
library(jsonlite)

# Set the environment variables
country <- Sys.getenv("country")
#state <- Sys.getnev("state")
#method <- Sys.getnev("method")

# Assign your URL to `url`
url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"

# Read the HTML table
df <- read.csv(url, header = TRUE)
col <- ncol(df)

mGT<-generation.time("gamma", c(2.45, 1.38))

#remove first few columns
scrap <- 6

#get province
#which(df[,1]=="Quebec",arr.ind=FALSE)
# get country
#which(df[,2]=="Russia",arr.ind=FALSE)

# get all data for 1 row
data <- df[45, scrap:col]
ndata <- as.numeric(data)
ndata
#calculate R0 for last 2 weeks
start<-min(which(ndata!=0))
l<-length(ndata)
est.R0.ML(ndata, mGT, begin=start, end=l, range=c(0.01,50))
v<-rep(NA,l-start+1)
w<-rep(NA,l-start+1)
z<-rep(NA,l-start+1)
for (i in (start+1):l){
    v[i-start+1]<-est.R0.ML(ndata, mGT, begin=start, end=i, range=c(0.01,50))[1]
    w[i-start+1]<-est.R0.ML(ndata, mGT, begin=start, end=i, range=c(0.01,50))$conf.int[1]
    z[i-start+1]<-est.R0.ML(ndata, mGT, begin=start, end=i, range=c(0.01,50))$conf.int[2]
}
plot(1:(l-start+1),v,frame=FALSE,ylim=c(0,2),col='red')
lines(1:(l-start+1),w,frame=FALSE,ylim=c(0,2),col='blue')
lines(1:(l-start+1),z,frame=FALSE,ylim=c(0,2),col='green')

#est.R0.EG(ndata, mGT, t = NULL, begin = NULL, end = NULL, date.first.obs = NULL,
#time.step = 1, reg.met = "poisson", checked = FALSE)


#est.R0.TD(ndata, mGT, begin=20, end=100, nsim=100)

# est.R0.SB(ndata, t = 20,  mGT, begin=NULL, end=NULL, date.first.obs = NULL,
# time.step = 1, force.prior=FALSE, checked = FALSE)
#ncol(df)
