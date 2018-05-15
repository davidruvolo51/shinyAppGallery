# make df
df <- subset(tsa, Field.Office == "DEN") # will put national totals here

newdf <- data.frame(df %>% 
                     group_by(Allegation, Year.Cased.Opened) %>% 
                     summarise(records = length(Field.Office)))


plot_ly(
    data = newdf,
    y = records,
    x = Year.Cased.Opened,
    mode = "marker-line",
    group = Allegation,
    color = Allegation,
    hoverinfo = "text",
    text = paste(unique(Allegation), "<br>",
                 "Year: ", Year.Cased.Opened, "<br>",
                 "Cases: ", records)
) %>% 
    #------------------
    # Layout Options
    layout(hovermode = "closest" ,
           xaxis = list(title = ""),
           yaxis = list(title = "No. of Allegations")) %>% 
    #------------------
    # Addition Options
    config(displayModeBar = F)

