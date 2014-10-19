library(shiny)
library(ggplot2)
library(rCharts)
library(maps)
library(mapproj)
library(stats)

data(USArrests)
crimetypes <- colnames(USArrests)

states_map <- map_data("state")

shinyServer(
        function(input, output) {
                output$title <- renderText(crimetypes[as.numeric(input$crime)])
                
                output$crimeMap <- renderPlot({
                        title <- paste0("Numer of Arrests for ",crimetypes[as.numeric(input$crime)],
                                        " per State in 1973 (per 100k Pop.)")
                        data <- data.frame(STATE = row.names(USArrests),
                                           NUM = USArrests[,as.numeric(input$crime)])
                        data$STATE <- tolower(as.character(data$STATE))
                        p <- ggplot(data, aes(map_id = STATE))
                        p <- p + geom_map(aes(fill = NUM), map = states_map, color='white') + expand_limits(x = states_map$long, y = states_map$lat)
                        p <- p + coord_map() + theme_bw()
                        p <- p + labs(x = "Longitude (W)", y = "Latitude (N)", title = title)
                        print(p)
                })

                output$crimeHist <- renderPlot({
                        binwid <- if (input$crime =="1") 0.5
                                  else if (input$crime == "2") 10
                                  else 1
                        qplot(USArrests[,as.numeric(input$crime)],
                              xlab = "Number of Arrests",
                              ylab = "Frequency",
                              main = paste0("Histogram of Frequency of Arrests for ",
                                            crimetypes[as.numeric(input$crime)],
                                            " per 100k Pop."),
                              stat = "bin", binwidth = binwid
                              ) + theme_bw()
                })
                
                output$crimeTrend <- renderPlot({
                        data <- data.frame(UrbanPop = USArrests$UrbanPop,
                                           number = USArrests[,as.numeric(input$crime)])
                        
                        p <- ggplot(data,aes(y=number,x=UrbanPop))
                        p <- p + labs(x = "Percent Urban Population",
                                      y = paste0("Number of Arrests for ",
                                                 crimetypes[as.numeric(input$crime)],
                                                 " per 100k Pop."),
                                      title = paste0(crimetypes[as.numeric(input$crime)],
                                                     " vs Percent Urban Population"))
                        p <- p + geom_point(color="blue")
                        p <- p + geom_smooth(method="lm",color="red")
                        p <- p + theme_bw()
                        print(p)
                })
        }
)
