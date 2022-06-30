library(shiny)
library(miniUI)
library(ggplot2)

g1 <- read.csv('g1.csv')
gA <- merge(g1[1:15,], g1[16:30,], by='Gene_ID')
names(gA)[names(gA) == "Relative_expression_levels.x"] <- 'Resistant_REL'
names(gA)[names(gA) == "Relative_expression_levels.y"] <- 'Susceptible_REL'

pick_points <- function(data=gA, x="Resistant_REL", y="Susceptible_REL") {
  
  ui <- miniPage(
    
    gadgetTitleBar(paste("Select points in", deparse(substitute(data)))), 
    miniContentPanel(padding = 0, 
                     plotOutput("plot1", height = "100%", brush = "brush")
    ), 
    miniButtonBlock(
      actionButton("add", "", icon = icon("thumbs-up")), 
      actionButton("sub", "", icon = icon("thumbs-down")), 
      actionButton("none", "", icon = icon("ban")), 
      actionButton("all", "", icon = icon("refresh"))
    )
  )
  
  server <- function(input, output, session) {
    vals <- reactiveValues(keep = rep(TRUE, nrow(data)))
    
    output$plot1 <- renderPlot({
      exclude <- data[!vals$keep, , drop = FALSE]
      include <- data[vals$keep, , drop = FALSE]
      
      ggplot(data, aes_string(x, y)) + 
        geom_point() + 
        geom_point(data = exclude, color = "grey80") + 
        geom_smooth(data = include)
    })
    
    selected <- reactive({
      brushedPoints(data, input$brush, allRows = TRUE)$selected_
    })
    
    observeEvent(input$add, vals$keep <- vals$keep | selected())
    observeEvent(input$sub, vals$keep <- vals$keep & !selected())
    observeEvent(input$all, vals$keep <- rep(TRUE, nrow(data)))
    observeEvent(input$none, vals$keep <- rep(FALSE, nrow(data)))
    
    observeEvent(input$done, {
      stopApp(data[vals$keep, , drop = FALSE])
    })
  }
  
  runGadget(ui, server)
}

pick_points()
