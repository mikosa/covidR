#library(R0)
library(ggplot2)
library(EpiEstim)
# Assign your URL to `url`
url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
df <- read.csv(url, header = TRUE)
col <- ncol(df)
#mGT<-generation.time("gamma", c(1, 1))
#remove first few columns
scrap<-5
#Creating a new  df with daily new cases
dailynewcases<-data.frame(df)
for (i in (scrap+1):col){
dailynewcases[,i]=df[,i]-df[,i-1]  
}
which(dailynewcases[,2]=="Canada" & dailynewcases[,1]=="Quebec")
Canadaallprovinces<-dailynewcases[36:46,scrap:col]
Canadaallinone<-rep(NA,col-scrap+1)
#b<-col-scrap+1
#for (i in 1:b){
 # Canadaallinone[i]<-sum(Canadaallprovinces[1:11,i])
#}
#v<-Canadaallinone[1:106]
v<-rep(NA,nrow(df))
for(i in 1:nrow(df)){
if(sum(as.numeric(dailynewcases[i,scrap:col])<0)>0)
  {v[i]<-i}
  
}
#omitting NA values
w<-na.omit(v)
dailynewcases[w,1:2]
x<-as.numeric(dailynewcases[1,scrap:col])
for (i in w){
  x<-as.numeric(dailynewcases[i,scrap:col])
  y<-which(x<0)
  u<-rep(1,length(y))
  m<-pmax(y-30,u)
  w<-x[y]
  x[y]<-round((x[y+1]+x[y-1])/2)
  for ( j in 1:length(y)){
    t<-w[j]
    coeff<-t/sum(x[m[j]:(y[j]-1)])
    x[m[j]:(y[j]-1)]<-round((1+coeff)*x[m[j]:(y[j]-1)])
  }
  dailynewcases[i,scrap:col]<-x
}
PlotRwithconfint<-function(Province,Country)
{
  
  whichprovcountry<-which(dailynewcases[,2]==Country& dailynewcases[,1]== Province)
  provdata<-as.numeric(dailynewcases[whichprovcountry,scrap:col])
  start100<-min(which(cumsum(provdata)>=100))
  res<-estimate_R(provdata[start100:col-scrap], method = "parametric_si",
                    config = make_config(list(
                      mean_si = 3, std_si = 2)))
  
  Rstats<-res$R
  Rmean<-Rstats$`Mean(R)`
  
  Rupper<-Rstats$`Quantile.0.025(R)`
  Rlower<-Rstats$`Quantile.0.975(R)`
  confdf<-data.frame(Rstats$t_end,Rmean,Rupper,Rlower)
  return(
      ggplot(confdf, aes(x = Rstats$t_end, y = Rmean))+
      geom_line(type="dashed",col="blue") +
      geom_errorbar(aes(ymax =Rupper, ymin =Rlower))+
      ggtitle(paste("Reproduction Number for the province of",Province,Country)) +
      labs(x="Day after 100th infection", y="R") +
      ggsave("mtcars.png")
    )
  
}
PlotRwithconfint("British Columbia","Canada")
#PlotRwithconfint("Quebec","Canada")
#PlotRwithconfint("Alberta","Canada")
#PlotRwithconfint("Saskatchewan","Canada")