library(shiny)
library(tidyverse)
library(dplyr)
library(datateachr)
library(DT)

#Loading in dataset
steam_games_condensed <- steam_games %>%
  select(name, genre, original_price) %>%
  drop_na() %>%
  filter(original_price < 1000) %>% #Correcting for errors in the dataset, which listed 2 games as costing >$100,000
  separate_rows(genre, sep = ",") #Will allow for selecting individual genres


#Checkbox inputs
genre_names <- sort(unique(steam_games_condensed$genre))

#ui
ui <- fluidPage(
  titlePanel("Steam Game Explorer"),
  h4("Use this app to explore steam games."),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", 0, 1000, c(0, 80), pre = "$"),
      checkboxGroupInput("genreInput", "Genre", choices = c("All", genre_names), selected = NULL)
    ),
    mainPanel(
      DTOutput("steamTable")
    )
  )
)

#server
server <- function(input, output, session) {
  #Include option to select all genres. If 
  observeEvent(input$genreInput, {
    if("All" %in% input$genreInput) {
      updateCheckboxGroupInput(session, "genreInput", selected = genre_names)
    } else if(length(input$genreInput) == 0) {
      updateCheckboxGroupInput(session, "genreInput", selected = NULL)
    }
  })
  
  #Filtering by price and genre
  filtered_games <- reactive({
    steam_games_condensed %>%
      filter(
        original_price >= input$priceInput[1],
        original_price <= input$priceInput[2],
        genre %in% input$genreInput
      ) %>%
      group_by(name, original_price) %>%
      summarize(genres = paste(unique(genre), collapse = ", "), .groups = "drop")
  })
  
  #Create an interactive table in the main panel
  output$steamTable <- renderDT({
    filtered_games() %>%
      datatable(
        options = list(
          pageLength = 100,
          lengthMenu = c(100, 200, 500),
          autoWidth = TRUE,
          order = list(list(0, 'asc'))
        ),
        colnames = c("Name", "Release Price", "Genre(s)")
      )
  })
}
  
#Run the application
shinyApp(ui = ui, server = server)
