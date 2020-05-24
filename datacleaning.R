# Read world data 
url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
df <- read.csv(url, header = TRUE)
rownames(df)<-NULL
#Read USA data
urlusa<-"https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
dfusa<-read.csv(urlusa,header=TRUE)
rownames(dfusa)<-NULL
#Removing useless data from world data and US data
df<-df[,-c(3:4)]
dfusa<-dfusa[,-c(1:6,9:11)]
#Counting columns and rows of dataframes
col<-ncol(df)
rowusa<-nrow(dfusa)
#Start counting at third column
scrap<-3
#Swap the first two columns
df<-(df[,c(2,1,3:col)])
dfusa<-dfusa[,c(2,1,3:col)]
df[,1]<-as.character(df[,1])
df[,2]<-as.character(df[,2])
#Sum up each of the US provinces
sumupUSAprovince<-function(state){
  cleanusa<-rep(0,col)
  y<-which(dfusa[,2]==state)
  cleanusa[2]<-state
  cleanusa[1]<-"United States"
  for(j in scrap:col){
    cleanusa[j]<-sum(as.numeric(dfusa[y,j]))
  }
  return(cleanusa)
}
#Creating one table for all the states for USA
dfusa[,2]<-as.factor(dfusa[,2])
USAdata<-matrix(0,nrow=length(levels(dfusa[,2])), ncol=col)
for (i in 1:length(levels(dfusa[,2]))){
  USAdata[i,]<-sumupUSAprovince(levels(dfusa[,2])[i])
}
USAdata[,1]<-"United States"
colnames(USAdata)<-colnames(df)
df<-rbind(df,USAdata)
#Removing Diamond Princess and Grand Princess from df occuring at rows 89,232,276
diamond<-(which(df[,1]=="Diamond Princess" | df[,2]=="Diamond Princess"))
df<-df[-diamond,]
grand<-which(df[,2]=="Grand Princess")
df<-df[-grand,]
#Treating far territories as countries
df[,1]<-as.character(df[,1])
df[,2]<-as.character(df[,2])
countrieswithterritories<-c("France","United Kingdom","Netherlands","Denmark")
for (i in countrieswithterritories){
  t<-which(df[,1]==i &df[,2]!= "")
  df[t,1]<-df[t,2]
  df[t,2]=""
}
usaterr<-c("American Samoa","Guam","Northern Mariana Islands","Virgin Islands","Puerto Rico")
for (i in 1:length(usaterr)){
  usaterrw<-which(df[,2]==usaterr[i])
  df[usaterrw,1]<-df[usaterrw,2]
  df[usaterrw,2]=""
}

df[which(df[,1]=="US"),1]<-"United States"
#Summing up provinces in the 
dataframe<-df
sumupcountry<-function(country)
{
  
  countrytotal<-rep(0,col)
  y<-which(dataframe[,1]==country)
  countrytotal[1]<-country
  countrytotal[2]= ""
  for (j in scrap:col){
    countrytotal[j]<-sum(as.numeric(dataframe[y,j]))
  }
  return(countrytotal)
}
#Creating a new  df with daily new cases
#Checking for countries with provinces except USA
tableofcountries<-table(df[,1])
x<-which(tableofcountries>1 &rownames(tableofcountries)!="United States")
countrieswithprovinces<-rownames(tableofcountries)[x]
Countrieswithprovincestotal<-matrix(0,nrow=length(countrieswithprovinces),ncol=col)
for (i in 1:length(countrieswithprovinces)){
  Countrieswithprovincestotal[i,]<-sumupcountry(countrieswithprovinces[i])
}
colnames(Countrieswithprovincestotal)<-colnames(df)
Countrieswithprovincestotal<-data.frame(Countrieswithprovincestotal)
df<-rbind(df,Countrieswithprovincestotal)
df<-df[order(df[,1],df[,2]),]
rownames(df)<-c(1:nrow(df))
dailynewcases<-df
dailynewcases[,scrap]<-as.numeric(dailynewcases[,scrap])
for (i in (scrap+1):col){
  dailynewcases[,i]<-as.numeric(dailynewcases[,i])
  df[,i]<-as.numeric(df[,i])
  df[,i-1]<-as.numeric(df[,i-1])
  dailynewcases[,i]=as.numeric(df[,i])-as.numeric(df[,i-1])  
}
CheckNegentries<-function(d){
  d<-dailynewcases
  v<-rep(NA,nrow(d))
  for(i in 1:nrow(d)){
    if(sum(as.numeric(d[i,scrap:col])<0)>0)
    {v[i]<-i}
  }
  return(v)
}
w<-na.omit(CheckNegentries(dailynewcases))
x<-as.numeric(dailynewcases[1,scrap:col])
for (i in w){
  x<-as.numeric(dailynewcases[i,scrap:col])
  y<-which(x<0)
  u<-rep(1,length(y))
  m<-pmax(y-30,u)
  s<-x[y]
  x[y]<-max(x[y-1],0)
  for ( j in 1:length(y)){
    t<-s[j]
    coeff<-t/sum(x[m[j]:(y[j]-1)])
    x[m[j]:(y[j]-1)]<-round((1+coeff)*x[m[j]:(y[j]-1)])
  }
  dailynewcases[i,scrap:col]<-as.numeric(dailynewcases[i,scrap:col])
  dailynewcases[i,scrap:col]<-x
}
