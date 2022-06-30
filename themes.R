# ==== TASk - 6 themes ==========================================================
# ==== global.R START ===========================================================
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
library(shiny)
library(ggplot2)
library(DT)
library(GeneBook)
library(shinythemes)
library(shinydashboard)
gn <- read.csv('./inc/genes_names.csv')
g1 <- read.csv("./inc/g1.csv")
g2 <- read.csv("./inc/g2.csv")
g3 <- read.csv("./inc/g3.csv")
# ===================================================== global.R END ============

# ==== ui.R START ===============================================================    
# Define UI for the application 
#
# uncomment and run the following line to 
# file.edit('C:/Users/Administrator/shiny2020/Task-6/themes/www/mytheme.css')
# file.edit('C:/Users/Administrator/shiny2020/Task-6/themes/www/bootstrap.css')
# file.edit('C:/Users/Administrator/shiny2020/Task-6/themes/www/bootstrap.min.css')
# 
# Remove the hash before theme to activate the css. 
# also try 'bootstrap.min.css' and 'bootstrap.css'

ui <- fluidPage(  # theme = "mytheme.css",
                  shinythemes::themeSelector(),
                  theme = shinytheme("darkly"),

    # Application title
    titlePanel("Gene Expression"),

    # Sidebar
    sidebarLayout(
        # Remove the next hash to change the sidebar theme
        sidebarPanel(#  tags$style(".well {background-color:black;}"),
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
                choices = levels(gn$GeneID)),

            selectInput(
                inputId = "More_info",
                label = "C- Documentation:",
                choices = c('Introduction', 'Information', 'Help',
                            'References', 'Table-1','Table-2','Table-3'),
                selected = "Introduction")
            # ,
            # submitButton(
            #     text = "Apply Changes",
            #     icon = icon("sliders"), # try: 'download', 'close', 'refresh', 'calendar', 'cog'
            #     width ='200px') # Replace with width ='80%'

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

# ==== NEW UI using shinydashboard ==============================================
ui <- dashboardPage(
    dashboardHeader(title = "Gene Expression"),

    dashboardSidebar(

    ),

    dashboardBody(

    )
)

# ===================================================== NEW UI END ==============

# ==== server.R START ===========================================================
# Define server logic 
# To access any input use input$[inputId] 
#                     ex. input$G_groups (the first select input value)
# To assign any output use output$[outputId] output$
#                      ex. output$myplot (assign the plot output)
server <- function(input, output) {
    output$odataset <- renderPrint({
        paste(input$My_dataset," = ", gn$Gene[gn$GeneID==input$My_dataset])
    })

    # using GeneBook library to construct a link to the gene database
    abbreviation <- reactive((GeneCard_ID_Convert(input$My_dataset)))

    # output for the odataset_link
    output$odataset_link <- renderPrint({
        tags$a(
            href = paste(
                "https://www.genecards.org/cgi-bin/carddisp.pl?gene=",
                as.character(abbreviation()[1]),
                sep = ''
            ),
            as.character(abbreviation()[1])
        )
    })


    full_file_name <-reactive(paste("./inc/", input$G_groups, ".csv", sep = ""))

    output$downloadData <- downloadHandler(
        
        filename = full_file_name,
        content = function(file){
            write.csv(read.csv(full_file_name()), quote = FALSE,file)
        } )

    output$myplot = renderPlot({
        g_x <- read.csv(full_file_name())

        p <- ggplot(g_x, aes(x=Gene_ID, y=log(Relative_expression_levels),
                             fill=Resistant_or_Susceptible_strains)) +

            geom_bar(stat="identity", position=position_dodge()) +
            geom_errorbar(aes(ymin=log(Relative_expression_levels)-(SD/10),
                              ymax=log(Relative_expression_levels)+(SD/10)),width=.3,
                          position=position_dodge(.9))
        p + scale_fill_brewer(palette="Paired")+
            ggtitle(paste("Relative expression levels of candidate gene list","\n",
                          "expressed as mean fold difference between pre- and",
                          "\n", "post-infection ± standard deviation (SD) ")) +
            guides(fill=guide_legend(title=NULL))

        p$theme <- theme(axis.text.x = element_text(angle = 90, hjust = 1))
        p$labels$x <- "Gene ID"
        p$labels$y <- "Log (base 10) Relative Expression Levels"
        p$labels$fill <- NULL

        return(p)

    })


    # renderDT() from DT library is a replacement for Shiny renderDataTable()
    output$datatable1 <- renderDT(datatable(g1))
    output$datatable2 <- renderDT(datatable(g2))
    output$datatable3 <- renderDT(datatable(g3))

    output$text1 <- renderUI({
        if(input$More_info=="Introduction"){
            includeHTML("inc/introduction.html")
        } else if(input$More_info=="Information"){
            includeHTML("inc/information.html")
        } else if(input$More_info=="Help"){
            includeHTML("inc/help.html")
        } else if(input$More_info=="Table-1"){
            DTOutput('datatable1')
        } else if(input$More_info=="Table-2"){
            DTOutput('datatable2')
        } else if(input$More_info=="Table-3"){
            DTOutput('datatable3')
        } else if(input$More_info=="References"){
            includeHTML("inc/references.html")
        }
    })
    }
# ===================================================== server.R END ============

# Run the application 
shinyApp(ui = ui, server = server)
