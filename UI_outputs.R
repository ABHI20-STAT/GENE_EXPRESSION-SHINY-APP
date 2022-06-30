# ==== TASk - 4 OUTPUTS ==========================================================
# ==== global.R START ===========================================================
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
library(shiny)
gn <- read.csv('genes_names.csv')
# ===================================================== global.R END ============

# ==== ui.R START ===============================================================    
# Define UI for the application 
ui <- fluidPage(
  
  # Application title
  titlePanel("Gene Expression"),
  
  # Sidebar 
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId ="G_groups",
        label = "A- Choose Group to plot:",
        choices = c("1- Genes down regulated in resistant while
                       up regulated in susceptible " = "g1",
                    "2- Genes down regulated in both resistant
                       and susceptible" = "g2",
                    "3- Genes up regulated in both resistant and
                       susceptible " = "g3"))
      , # We need comma between each input
      
      selectInput(
        inputId = "My_dataset",
        label = "B- Choose Gene ID to show it's full name:",
        choices = as.character(gn$GeneID)),
      
      selectInput(
        inputId = "More_info",
        label = "C- Documentation:",
        choices = c('Introduction', 'Information', 'Help',
                    'References', 'Table-1','Table-2','Table-3'),
        selected = "Information")
      , # Another comma here

      submitButton(
          text = "Apply Changes",
          icon = icon("sliders"), # Try other icon: 'area-chart', 'calendar', 'close', 'download',
                                  #                 'map-o', 'refresh', 'sliders', 'table'
          width ='200px') # Replace with width ='80%'
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      downloadButton(
          outputId = "downloadData",
          label = "Download Data"),

      plotOutput(
          outputId = "myplot",
          width = "100%",
          height = "400px"),

      verbatimTextOutput(
          outputId = "odataset"),

      uiOutput(
          outputId = "odataset_link"),

      uiOutput(
          outputId = "text1")
      
    )
  )
)

# ===================================================== ui.R END ================

# ==== server.R START ===========================================================
# Define server logic 
server <- function(input, output) {
  
}
# ===================================================== server.R END ============

# Run the application 
shinyApp(ui = ui, server = server)
