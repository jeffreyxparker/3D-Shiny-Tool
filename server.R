library(shiny)
library(tidyverse)
library(plotly)



# Define a server for the Shiny app
function(input, output, session) {
  
  # Read the input file and fix the names
  my_data <- reactive({
    inFile <- input$file_inputter
    if (is.null(inFile)) return(NULL)
    my_data <- read_csv(inFile$datapath)
    new_names <- gsub(" ",".",names(my_data))
    colnames(my_data) <- new_names
    as_tibble(my_data)
  })
  
  observe({
  
    # Change values for X, Y and Z column selections
    s_options <- as.list(colnames(my_data()))
    updateSelectInput(session = session, inputId = "xcol", choices = s_options, selected = colnames(my_data())[1])
    updateSelectInput(session = session, inputId = "ycol", choices = s_options, selected = colnames(my_data())[15])
    updateSelectInput(session = session, inputId = "zcol", choices = s_options, selected = colnames(my_data())[25])
  })
  
  observe({

    # Change the values for the filter selections
    xf_options <- as.list(sort(unique(my_data()[[input$xcol]])))
    yf_options <- as.list(sort(unique(my_data()[[input$ycol]])))
    zf_options <- as.list(sort(unique(my_data()[[input$zcol]])))
    updateSelectInput(session = session, inputId = "x_filter", choices = xf_options, selected = xf_options)
    updateSelectInput(session = session, inputId = "y_filter", choices = yf_options, selected = yf_options)
    updateSelectInput(session = session, inputId = "z_filter", choices = zf_options, selected = zf_options)
  })
  
  # Output the 3D graph
  output$plot <- renderPlotly({
    
    # Filter
    data2 <- my_data() %>%
      select(x = input$xcol, y = input$ycol, z = input$zcol)  %>%
      filter(x %in% input$x_filter,
             y %in% input$y_filter,
             z %in% input$z_filter)%>%
      group_by(x,y)
    
    # Pivot
    if(input$sum_func == "sum"){
      data2<- data2 %>%
      summarise(total = sum(z, na.rm = TRUE)) %>%
      spread(x, total)}
    if(input$sum_func == "mean"){
      data2<- data2 %>%
        summarise(total = mean(z, na.rm = TRUE)) %>%
        spread(x, total)}
    if(input$sum_func == "max"){
      data2<- data2 %>%
        summarise(total = max(z, na.rm = TRUE)) %>%
        spread(x, total)}
    if(input$sum_func == "min"){
      data2<- data2 %>%
        summarise(total = min(z, na.rm = TRUE)) %>%
        spread(x, total)}

    # Find the needed variables
    x_vec <- colnames(data2)
    y_vec <- data2[[1]]
    z_matrix <- as.matrix(data2[,-1])

    # Plot the chart
    plot_ly(x = x_vec, y = y_vec, z = z_matrix) %>%
      add_surface()  %>%
      layout(
        title = paste(input$xcol,"by",input$ycol,"by",input$zcol),
        scene = list(
          xaxis = list(title = input$xcol),
          yaxis = list(title = input$ycol),
          zaxis = list(title = input$zcol)
        ))
    })
 
}