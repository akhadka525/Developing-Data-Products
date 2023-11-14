# server.R
#
# CO2 analysis from inbuilt data

library(shiny)
library(forecast)
library(ggplot2)
library(datasets)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    ## Load CO2 data
    data(co2)
    ts_co2 <- ts(co2, start = c(1959,1), frequency = 12)
    decomCo2 <- decompose(ts_co2, "multiplicative")
    mymodel <- auto.arima(ts_co2)
    myForecast <- forecast(mymodel, level = c(95), h=15*12)
    
    ## reactive subset based on plot type
    data <- reactive({
        switch (input$plot_type,
                "Time Series" = ts_co2,
                "Time Series with Trend" = ts_co2,
                "Trend" = decomCo2,
                "Seasonality" = decomCo2,
                "Residual" = decomCo2,
                "Monthly Boxplot" = ts_co2,
                "15 Year Forecast" = myForecast)
        
    })
    
    
    ## Render selected plot
    output$selected_plot <- renderPlot({
        switch (input$plot_type,
                "Time Series" = {
                    plot(ts_co2, xlab = "Date", 
                         ylab = " CO2 concentration (ppm)",
                         main = "")
                },
                
                "Time Series with Trend" = {
                    plot(ts_co2, xlab = "Date", 
                         ylab = " CO2 concentration (ppm)",
                         main = "")
                    abline(reg = lm(ts_co2~time(ts_co2)))
                },
                
                "Trend" = {
                    plot(decomCo2$trend, xlab = "Date", 
                         ylab = " CO2 concentration (ppm)",
                         main = "Trendline")
                },
                
                "Seasonality" = {
                    plot(decomCo2$seasonal, xlab = "Date", 
                         ylab = "",
                         main = "Seasonality Plot")
                },
                
                "Residual" = {
                    plot(decomCo2$random, xlab = "Date", 
                         ylab = "",
                         main = "Residual Plot")
                },
                
                "Monthly Boxplot" = {
                    boxplot(ts_co2~cycle(ts_co2), xlab = "Months", 
                            ylab = " CO2 concentration (ppm)",
                            main = "")
                },
                
                "15 Year Forecast" = {
                    plot(myForecast, xlab = "Date", 
                         ylab = " CO2 concentration (ppm)",
                         main = "")
                })
    })
    
    ## Render for output summary
    output$summary_output_sidebar <- renderPrint({
        summary(ts_co2)
    })
    
})
