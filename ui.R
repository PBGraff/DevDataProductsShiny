library(shiny)

shinyUI(fluidPage(
        titlePanel("Violent Crime in the US in 1973"),
        
        fluidRow(
                p("This application will display data on violent crime rates in the United States in 1973.
                  The arrest rates for murder, assault, and rape are measured per 100,000 population."),
                br(),
                p("The Map tab will show the rates on a map of the 48 contiguous states with a color
                  gradient indicating the number of arrests for the chosen crime. The Histrogram tab
                  displays a histogram of the data to analyze the frequency of the different arrest
                  rates. Lastly, the Trend tab displays a scatterplot and linear fit of the trend
                  relating the arrest rate to the percentage of urban population in the state."),
                br()
        ),
        
        sidebarLayout(
            sidebarPanel(
                textOutput("This will be a paragraph of text."),
                selectInput("crime","Crime Type:",
                            list("Murder" = "1", "Assault" = "2",
                                 "Rape" = "4"))
            ),
            
            mainPanel(
                tabsetPanel(
                    tabPanel("Map",plotOutput('crimeMap')),
                    tabPanel("Histogram",plotOutput('crimeHist')),
                    tabPanel("Trend",plotOutput('crimeTrend'))
                )
            )
        )
))
