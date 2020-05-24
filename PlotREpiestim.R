
PlotRwithconfint<-function(Country,Province)
{
  
  whichprovcountry<-which(dailynewcases[,1]==Country& dailynewcases[,2]== Province)
  provdata<-as.numeric(dailynewcases[whichprovcountry,scrap:col])
  start100<-min(which(cumsum(provdata)>=100))
  res<-estimate_R(provdata[start100:(col-scrap)], method = "parametric_si",
                    config = make_config(list(
                      mean_si = 3, std_si = 2)))
  
  Rstats<-res$R
  Rmean<-Rstats$`Mean(R)`
  
  Rupper<-Rstats$`Quantile.0.025(R)`
  Rlower<-Rstats$`Quantile.0.975(R)`
  confdf<-data.frame(Rstats$t_end,Rmean,Rupper,Rlower)
  title<-ifelse(Province=="",paste("Reproduction Number for",Country),
        paste("Reproduction Number for",Province,",",Country))
                                                                                
   
  
  return(
    ggplot(confdf, aes(x = Rstats$t_end, y = Rmean))+
           geom_line(type="dashed",col="blue") +
     geom_errorbar(aes(ymax =Rupper, ymin =Rlower))+
     ggtitle(title) +
      labs(x="Day since 100-th infection", y="Reproduction Number")
    )
  
}