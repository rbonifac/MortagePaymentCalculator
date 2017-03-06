#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(ggplot2)
library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
  
  # Application title
  titlePanel("Mortgate Payment Calculator"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        numericInput('Price', 'Home Price', 300000),
        numericInput('Down', 'Down Payment', 40000),
        
        selectInput('loan', 'Loan Type', c('30 Year Fixed','20 Year Fixed','15 Year Fixed')),
        sliderInput("Rate",
                    "Interest Rate:",
                    min = 1.0,
                    max = 20.0,
                    value = 4.0)
      ,submitButton("Submit")
     
      ),

    # Show a plot of the generated distribution
    mainPanel(
       plotlyOutput("plot1")
       ##,textOutput("pmt1")
       
    )
  )
))
