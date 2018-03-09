library(shiny)

ui <- fluidPage(
  
  titlePanel("Header goes here"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      sliderInput(inputId ="num", label = "Choose a number", min = 1, max = 100, value = 25)),
    
      mainPanel(
        
           plotOutput(outputId = "myPlot", width = "100%", height = "400px")
  )
    )
)

server <- function(input, output) {
  
  output$myPlot <- renderPlot({
    
    hist(rnorm(10000, mean = 100, sd = 5), breaks = input$num)
    
  })
}

shinyApp(ui, server)



