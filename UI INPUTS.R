# ==== TASk - 3 INPUTS ==========================================================
# ==== global.R START ===========================================================
# 
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
library(shiny)
gn <- read.csv('genes_names.csv')
# ==================================================== global.R END =============

# ==== ui.R START ===============================================================    
# Define UI for the application 
ui <- fluidPage(
  
  # Application title
  titlePanel("Gene Expression"),
  
  # Sidebar 
  sidebarLayout(
    sidebarPanel(
      
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
      ,         # We need comma between each input
      selectInput(
          inputId ="G_groups",
          label = "A- Choose Group to plot:",
          choices = c("1- Genes down regulated in resistant while
                 up regulated in susceptible " = "g1",
                      "2- Genes down regulated in both resistant
                 and susceptible" = "g2",
                      "3- Genes up regulated in both resistant and
                 susceptible " = "g3")),

      selectInput(
          inputId = "My_dataset",
          label = "B- Choose Gene ID to show it's full name:",
          choices = as.character(gn$GeneID)),


      selectInput(
          inputId = "More_info",
          label = "C- Documentation:",
          choices = c('Introduction', 'Information', 'Help',
                      'References', 'Table-1','Table-2','Table-3'),
          selected = "Information"),
      # 
      # textInput(
      #     inputId = "name",
      #     label = "Species name:",
      #     placeholder = "Streptococcal Sepsis"),
      # 
      # radioButtons(
      #     inputId = "radio",
      #     label = "Strain type",
      #     choices = c("Resistant", "Susceptible")),
      # 
      # checkboxInput(
      #     inputId= "checkbox",
      #     label = "GROUP A STREP?", 
      #     value = FALSE),
      # 
      # checkboxGroupInput(
      #     inputId = "multicheckbox", 
      #     label= "Sample type", 
      #     choices = c("ssRNA", "dsRNA", "ssDNA", "dsDNA")),
      # 
      # dateInput(
      #     inputId = "date", 
      #     label = "Select sample date:"),
      # 
      # fileInput(
      #     inputId = "file", 
      #     label = "Select file"),
      # numericInput(
      #     inputId = "volume", 
      #     label = "Enter sample volume (uL):", 
      #     value = 20),
      # 
      # passwordInput(
      #     inputId = "password", 
      #     label = "Enter password" ),
      # 
      # selectInput(
      #     inputId = "bxd", 
      #     label = "bxd strain:", 
      #     choices = c("DBA/2J", "C57Bl/6J")),
      # 
      # sliderInput(
      #     inputId = "gene", 
      #     label = "gene expresion level:", 
      #     min = 0, 
      #     step = 0.1, 
      #     max = 100, 
      #     value = 27.1)
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
      
    )
  )
)

# ===================================================== ui.R END ================

# ==== server.R START ===========================================================
# Define server logic required to draw a histogram
server <- function(input, output) {
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
}
# ===================================================== server.R END ============

# Run the application 
shinyApp(ui = ui, server = server)
