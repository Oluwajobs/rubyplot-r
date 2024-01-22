#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# defining ui for the view
ui <- fluidPage(
  titlePanel("ML Predictor"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Upload Your Dataset'),
      selectInput('sampleData', 'Or Choose a Sample Dataset', choices = c('Sample 1', 'Sample 2')),
      uiOutput('selectTarget'),
      uiOutput('selectFeatures'),
      selectInput('algorithm', 'Choose an Algorithm', choices = c('Algorithm 1', 'Algorithm 2')),
      numericInput('cvParameter', 'Set CV Parameter', value = 10),
      sliderInput('testData', 'Percentage of Data for Testing', min = 0, max = 100, value = 30)
    ),
    
    mainPanel(
      textOutput("summary")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Reactive expression to read the dataset
  datasetInput <- reactive({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    read.csv(inFile$datapath)
  })
  
  # Output UI for target variable selection
  output$selectTarget <- renderUI({
    df <- datasetInput()
    if (is.null(df)) return(NULL)
    selectInput('targetVariable', 'Select Target Variable', choices = names(df))
  })
  
  # Output UI for feature selection
  output$selectFeatures <- renderUI({
    df <- datasetInput()
    if (is.null(df)) return(NULL)
    checkboxGroupInput('features', 'Select Features', choices = names(df))
  })
  
  # Summary of user inputs
  output$summary <- renderText({
    paste("You have selected", input$targetVariable, "as the target variable and",
          toString(input$features), "as features with", input$algorithm,
          "algorithm and a test data percentage of", input$testData, "%.")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
