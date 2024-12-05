library(shiny)
library(tidyverse)
library(DT)

# Load dataset
imdb1000_unfiltered <- read_csv("imdb_top_1000.csv")

# Preprocess dataset
movies <- imdb1000_unfiltered %>%
  select(-Poster_Link, -Certificate, -Star1, -Star2, -Star3, -Star4) %>%
  rename(
    Title = Series_Title,
    `Year Released` = Released_Year,
    Runtime = Runtime,
    Genres = Genre,
    `IMDb Rating` = IMDB_Rating,
    Overview = Overview,
    `Meta Score` = Meta_score,
    Director = Director,
    `Number of Votes` = No_of_Votes,
    `USA Gross` = Gross
  ) %>%
  mutate(`USA Gross` = as.numeric(`USA Gross`))  
getwd()
# Checkbox inputs
genre_names <- sort(unique(unlist(strsplit(imdb1000_unfiltered$Genre, ", "))))

# UI
ui <- fluidPage(
  titlePanel("IMDB Top 1000 Movies"),
  h4("Use this app to explore IMDB's 1000 top-rated movies."),
  h6("Features to explore:", br(),
     "1. Slider: to filter by year released.", br(),
     "2. Checkboxes: to filter by genre", br(),
     "3. Interactive table: for searching keywords or sorting by ascending/descending value for any column.", br(),
     "4. Text output: provides updates on how many movies match the current filtering criteria", br(),
     "5. Image output: click on a title to see the movie cover!", br(),
     "6. Download button: download the full, unfiltered dataset"),
  
  sidebarLayout(
    sidebarPanel(
      width = 2,  
      sliderInput("yearInput", "Release Year", 1900, 2020, c(2000, 2020)),
      checkboxGroupInput(
        "genreInput", 
        "Genre", 
        choices = c("All", genre_names), 
        selected = NULL
      )
    ),
    
    mainPanel(
      width = 10,  
      downloadButton("downloadOriginalData", "Download Full Dataset"),
      htmlOutput("numMovies"),
      uiOutput("moviePoster"),
      DTOutput("movieTable")
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Filtering the reactive dataset
  filtered_movies <- reactive({
    req(input$genreInput)  
    
    filtered_data <- movies %>%
      filter(
        `Year Released` >= input$yearInput[1],
        `Year Released` <= input$yearInput[2],
        if (!"All" %in% input$genreInput) str_detect(Genres, paste(input$genreInput, collapse = "|")) else TRUE
      )
  })
  
  # Display the number of movies meeting the specified filtering criteria
  output$numMovies <- renderText({
    num_movies <- nrow(filtered_movies())
    HTML(paste("<span style='font-size: 20px; color: #1E90FF;'>Number of Movies in Filtered Set: ", num_movies, "</span>"))
  })
  
  # Create a table of filtered movies, with horizontal and vertical scroll
  output$movieTable <- renderDT({
    datatable(
      filtered_movies(),
      options = list(
        scrollX = TRUE,
        scrollY = "600px",
        scroller = TRUE,
        deferRender = TRUE,
        scrollCollapse = TRUE,
        paging = FALSE
      ),
      selection = 'single',
      rownames = FALSE
    ) %>%
      formatCurrency(columns = 'USA Gross', currency = "$", interval = 3, mark = ",", digits = 0)
  })
  
  # Display the movie poster when a title is clicked
  observeEvent(input$movieTable_rows_selected, {
    selected_row <- input$movieTable_rows_selected
    if (length(selected_row) > 0) {
      selected_movie <- filtered_movies()[selected_row, ]
      
      # Find the corresponding poster URL from the unfiltered dataset 
      movie_title <- selected_movie$Title
      movie_poster_url <- imdb1000_unfiltered %>%
        filter(Series_Title == movie_title) %>%
        select(Poster_Link) %>%
        pull() 
      
      # Show the movie poster in the UI
      output$moviePoster <- renderUI({
        tagList(
          h3(selected_movie$Title),  # Add movie title above poster
          img(src = movie_poster_url, height = "150px", width = "100px")
        )
      })
    }
  })
  
  # Download the original full dataset
  output$downloadOriginalData <- downloadHandler(
    filename = ("imdb_top_1000.csv"),
    content = function(file) {
      write.csv(imdb1000_unfiltered, file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)