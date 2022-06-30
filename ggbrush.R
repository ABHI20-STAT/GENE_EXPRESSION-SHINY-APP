library(shiny)
library(miniUI)
library(ggplot2)

g1 <- read.csv('./shiny2020/new/inc/g1.csv')
gA <- merge(g1[1:15,], g1[16:30,], by='Gene_ID')
names(gA)[names(gA) == "Relative_expression_levels.x"] <- 'Resistant_REL'
names(gA)[names(gA) == "Relative_expression_levels.y"] <- 'Susceptible_REL'

data <- gA
xvar <- 'Resistant_REL'
yvar <- 'Susceptible_REL'

ggbrush <- function(data = gA, x = xvar, y = yvar) {

  ui <- miniPage(
    gadgetTitleBar("Drag to select points"),
    miniContentPanel(
      plotOutput(
        outputId = "plot", 
        height = "100%", 
        brush = "brush")
    )
  )

  server <- function(input, output, session) {

    output$plot <- renderPlot({
      ggplot(data, aes_string(xvar, yvar)) + geom_point()
    })

    observeEvent(input$done, {
      stopApp(brushedPoints(data, input$brush))
    })
  }
  
  runGadget(ui, server)
}

ggbrush(gA, xvar, yvar)
