#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define server logic required to draw a plotly graph
shinyServer(function(input, output) {

    calcPmt<- reactive ({
    bal <- input$Price - input$Down
    if (input$loan == '30 Year Fixed') {
      dur <- 30 * 12
    } else if ( input$loan == '25 Year Fixed') {
      dur <- 20 * 12
    } else if ( input$loan == '15 Year Fixed') {
      dur <- 15 * 12
    }
    apr <- input$Rate/100/12
    #P = L[c(1 + c)n]/[(1 + c)n - 1] 
    pmt <- bal*((apr*(1+apr)^dur)/(((1+apr)^dur)-1))
    
    pYear <- 12
  
    int <- apr*bal
    #define and initialize dataframe
    df <- matrix(NA, nrow =dur, ncol = 8)
    colnames(df)<- c("pNo","pAmt","int","prAmt","lBal","prAc","intAc","pmtAc")
    
    df[1,] <- c(pNo=1,pAmt=pmt, int=int,prAmt=pmt-int,
                lBal=bal-int, prAc=pmt-int, intAc=int,pmtAc=pmt)
  
    #populate data frame with calculated values until the max number of payments.
    for (i in c(2:dur)) {
      df[i,1] <- i
      df[i,2] <- pmt
      df[i,3] <- apr*df[i-1,5]
      df[i,4] <- pmt - df[i,3]
      df[i,5] <- df[i-1,5]-df[i,4]
      df[i,6] <- df[i-1,6]+df[i,4]
      df[i,7] <- df[i-1,7]+df[i,3]
      df[i,8] <- df[i-1,8]+df[i,2]
      if (df[i,5] < 0) break;
    } 
    df <- as.data.frame(df)
  #define plotly for cumulative interest/principa and balance over the loan period  
  plot_ly(df, x = ~pNo, y = ~pmtAc, name = 'Interest', 
          type = 'scatter', mode = 'none', fill = 'tozeroy', fillcolor = '#F5FF8D')%>%
          add_trace(y = ~prAc, name = 'Principal', fillcolor = '#50CB86') %>%
           add_lines(y= ~lBal, name="Balance", fill= FALSE, mode='lines',fillcolor='black')%>%
     layout(title = 'Loan Payment Amortization',
         xaxis = list(title = "Monthly Payments",
                      showgrid = FALSE),
         yaxis = list(title = "Currency",
                      showgrid = FALSE))

  })
  
   output$plot1 <- renderPlotly(calcPmt())
   ##output$pmt1 <- renderText("Monthly Payment:",pmt)
  }
 )
  