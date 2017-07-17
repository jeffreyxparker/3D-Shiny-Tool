library(shiny)
library(tidyverse)
library(plotly)


shinyUI(
  fluidPage(    
    titlePanel("3D Visualizations"),
    sidebarLayout(

      sidebarPanel(
          fileInput(inputId = "file_inputter", label = "Upload Your Data", accept='.csv'),
          selectInput(inputId = "xcol", label = "X Variable", choices = NULL),
          selectInput(inputId = "ycol", label = "Y Variable", choices = NULL),
          selectInput(inputId = "zcol", label = "Z Variable", choices = NULL),
          selectInput('x_filter', 'X Filter', choices = NULL, selectize=FALSE, multiple = TRUE),
          selectInput('y_filter', 'Y Filter', choices = NULL, selectize=FALSE, multiple = TRUE),
          selectInput('z_filter', 'Z Filter', choices = NULL, selectize=FALSE, multiple = TRUE),
          radioButtons("sum_func", "Values of Pivot Table",
                       c("Sum" = "sum",
                         "Mean" = "mean",
                         "Max" = "max",
                         "Min" = "min"))
          ),
      mainPanel(
        plotlyOutput("plot", height = 750, width = 750)
      )
    )
    ### An Alternate Layout ###
    # fluidRow(
    #   column(
    #     4,
    #     selectInput(inputId = "xcol", label = "X Variable", choices = NULL),
    #     selectInput('x_filter', 'X Filter', choices = NULL, selectize=FALSE, multiple = TRUE)
    #   ),
    #   column(
    #     4,
    #     selectInput(inputId = "ycol", label = "Y Variable", choices = NULL),
    #     selectInput('y_filter', 'Y Filter', choices = NULL, selectize=FALSE, multiple = TRUE)
    #   ),
    #   column(
    #     4,
    #     selectInput(inputId = "zcol", label = "Z Variable", choices = NULL),
    #     selectInput('z_filter', 'Z Filter', choices = NULL, selectize=FALSE, multiple = TRUE)
    #   )
    # ),
    # fluidRow(
    #   plotlyOutput("plot")
    # ),
    # fluidRow(
    #   column(
    #     4,
    #     fileInput(inputId = "file_inputter", label = "Upload Your Data", accept='.csv')
    #   )
  )
)


