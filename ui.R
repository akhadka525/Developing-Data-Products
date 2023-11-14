# ui.R
#
# CO2 analysis from inbuilt data

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
        
        # Application title
        titlePanel("CO2 Data Analysis, 1959 - 1997"),
        
        # Sidebar with a slider input for number of bins
        sidebarLayout(
                sidebarPanel(
                        selectInput("plot_type", "Select Plot Type",
                                    choices = c("Time Series", "Time Series with Trend",
                                                "Trend", "Seasonality", "Residual",
                                                "Monthly Boxplot", "15 Year Forecast")),
                        actionButton("btn_submit", "Submit"),
                        verbatimTextOutput("summary_output_sidebar")
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                        plotOutput("selected_plot"),
                        verbatimTextOutput("Summary Output")
                        
                )
        )
))
