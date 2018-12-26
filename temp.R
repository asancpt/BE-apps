
# Data Input --------------------------------------------------------------

Input <- data.frame(t(read.table(InputParameter, row.names = 1, stringsAsFactors = FALSE)), stringsAsFactors = FALSE)
Input$Dose <- as.numeric(Input$Dose)

if (Input$Data == "Theoph") {
  Data <- Theoph
  colSubj <- "Subject"
  colTime <- "Time"
  colConc <- "conc"
} else {
  Data <- Indometh
  colSubj <- "Subject"
  colTime <- "time"
  colConc <- "conc"
}

IDs <- unique(Data[,colSubj])
nID <- length(IDs)

Output <- vector()
Output[1] <- paste("#NumField:",nID)
Output[2] <- paste("#LabelX: Time(h), LabelY: Conc(mg/L)")

cLineNo = 3

for (i in 1:nID) {
  cID = IDs[i]
  cDAT = Data[Data[,colSubj]==cID,]
  nRec = dim(cDAT)[1]
  Output[cLineNo] = paste0("#Field", cID, ": data, NumPoint:", nRec)
  cLineNo = cLineNo + 1
  for (j in 1:nRec) {
    Output[cLineNo] = paste(sprintf("%10.3f", cDAT[j, colTime]), sprintf("%10.3f",cDAT[j,colConc]))
    cLineNo = cLineNo + 1
  }
}

# Output ------------------------------------------------------------------

#write.csv(Data, "result/out.csv", quote=FALSE, row.names=FALSE)
#writeLines(Output, paste0("result/result.oneD"))

write_csv(Data, "result/out.csv")
write_lines(Output, "result/result.oneD")

tabResult <- NonCompart::tblNCA(Data, 
                   colSubj, 
                   colTime, 
                   colConc, 
                   adm = Input$AdmMode, 
                   down = Input$Log, 
                   dose=Input$Dose)
tabUnit <- tibble(param = attributes(tabResult)[['names']], units = attributes(tabResult)[['units']])

tab_nca_final <- tabResult %>% 
  as_tibble() %>% 
  gather(param, value, -1) %>% 
  left_join(tabUnit, by = 'param')

write_csv(tab_nca_final, 'result/resultNonCompart.csv')

plot_facet <- ggplot(Data, aes(x=Time, y=conc, group=Subject)) +
  geom_line() +
  geom_point() +
  facet_wrap(. ~ Subject, ncol = 4) +
  labs(x = "Time (h)", y = "Concentration (ng/uL)")
ggsave("result/plot.jpg", plot_facet, width = 8, height = 5, dpi = 300)

#knit("plot.Rmd", "plot.md")
knit2html("plot.Rmd", "result/plot.html", options = c("toc", "mathjax"))

# markdownToHTML("plot.md", "result/plot.html", options = c("toc", "mathjax"))

# browseURL("result/Report_Appendix.html")

