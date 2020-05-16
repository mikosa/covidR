library(R0)
library(ggplot2)
library(EpiEstim)
url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
df <- read.csv(url, header = TRUE)
col <- ncol(df)
scrap<-6
dailynewcases<-data.frame(df)
for (i in (scrap+1):col){
  dailynewcases[,i]=df[,i]-df[,i-1]  
}
Canadaallprovinces<-dailynewcases[36:46,scrap:col]
Canadaallinone<-rep(NA,col-scrap+1)
b<-col-scrap+1
for (i in 1:b){
  Canadaallinone[i]<-sum(Canadaallprovinces[1:11,i])
}
v<-Canadaallinone[1:106]
Quebec<-as.numeric(dailynewcases[45,scrap:col])
res <- estimate_R(v[49:106], method = "parametric_si",
                  config = make_config(list(
                    mean_si = 4, std_si = 5)))
Rstats<-res$R
Rmean<-Rstats$`Mean(R)`
Rupper<-Rstats$`Quantile.0.025(R)`
Rlower<-Rstats$`Quantile.0.975(R)`


plot(Rstats$t_end,Rstats$"Mean(R)",type="l",col="green")
lines(Rstats$t_end,Rupper,col="red")
lines(Rstats$t_end,Rlower,col="blue")

confdf<-data.frame(Rstats$t_end,Rstats$`Mean(R)`,Rupper,Rlower)
ggplot(confdf, aes(x = Rstats$t_end, y = Rstats$`Mean(R)`))
  geom_line(linetype="dashed") +
  geom_l(aes(ymax = Rupper, ymin = Rlower))

