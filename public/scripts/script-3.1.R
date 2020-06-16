Data<-read.csv("data.csv")

library(tidyr)
DataFix<-gather(Data,"year","abundance",9:53)
library(readr)
DataFix$year <- parse_number(DataFix$year)
names(DataFix)
names(DataFix) <- tolower(names(DataFix))
DataFix$abundance <- as.numeric(DataFix$abundance)

library(dplyr)
aphidNos<- DataFix %>%group_by(species)%>%summarise(Pop. = n())
aphidNos[1:5,1:2]

library(ggplot2)
ThemeForAphidNos <- function()
{
  theme_bw()+
    theme(axis.text.x=element_text(size=12, angle=45, vjust=1, hjust=1),axis.text.y=element_text(size=12),axis.title.x=element_text(size=14, face="plain"),axis.title.y=element_text(size=14, face="plain"),             
          panel.grid.major.x=element_blank(),panel.grid.minor.x=element_blank(),panel.grid.minor.y=element_blank(),panel.grid.major.y=element_blank(),  
          plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), units = , "cm"),
          plot.title = element_text(size=20, vjust=1, hjust=0.5),
          legend.text = element_text(size=12, face="italic"),legend.title = element_blank(),legend.position=c(0.9, 0.9))}

levels(DataFix$biome)
