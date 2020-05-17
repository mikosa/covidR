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
#start100<-min(which(cumsum(v)>5))
#start150<-min(which(cumsum(v)>100))
#x<-est.R0.ML(v[16:106],mGT,range=c(0.01,50))

#x<-est.R0.ML(v[start100:106],mGT, range=c(0.01,50))
#w<-as.numeric(dailynewcases[45,scrap:col])
#start100<-min(which(cumsum(w)>=1))
#start150<-min(which(cumsum(w)>150))
#x<-est.R0.ML(w[48:106],mGT,unknown.GT = TRUE)
#z<-as.numeric(dailynewcases[37,scrap:col])
#start100<-min(which(cumsum(z)>=150))
#start150<-min(which(cumsum(z)>150))
#x<-est.R0.SB(z[41:106],mGT,range=c(0.01,50),time.step = 1)
#SB<-est.R0.TD(z[41:106],mGT)
#dailynewcases[36,scrap:col]
#dailynewcases[,1:2]<-as.character(dailynewcases[,1:2])
#Changed dailynewcases[43,80]=0 from -7(Ontario)
dailynewcases[43,80]=0
#Changed dailynewcases[36,68]=0 from -1(Alberta)
dailynewcases[36,68]=0
#Changed dailynewcases[39,86]=0 from -1 (Manitoba)
dailynewcases[39,86]=0
#Changed dailynewcases[39,111]=0 from -3 (Manitoba)
dailynewcases[39,111]=0
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