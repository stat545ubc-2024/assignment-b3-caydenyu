# Assignments B3 & B4

## Description

This repository contains the files for assignments B3 and B4. For assignment B4, I have chosen to make a new shiny app.

The 'assignment-b3-caydenyu/app.R' file is the SteamGames app. It uses the 'steam_games' dataset from the 'datateachr' package. This app allows users to explore the games offered in the Steam library. The 3 main features include a slider, checkboxes, and an interactive table. The slider allows the user to specify a price range so they only see games within their budget. The checkboxes allow the user to specify which genre(s) they are interested in, enabling additional filtering. The interactive table itself contains many smaller features, including the ability to select how many items are displayed at a time, the ability to search for a specific title, and the ability to sort each column by ascending/descending order.

The 'assignment-b3-caydenyu/assignment-b4' folder contains the files for assignment B4. For this assignment, I have chosen to complete option C (Shiny app). This folder includes the imdb_top_1000.csv dataset and an app.R file containing the code for the IMDb1000 app (different from the 'assignment-b3-caydenyu/app.R file'). This app allows users to explore the 1000 top rated movies on the IMDb website. It has 6 features:

1.  **Slider:** The slider input enables users to filter the dataset to display only movies released within a specified range of years.
2.  **Checkboxes:** This feature allows users to check one or multiple movie genres that they are interested in, further filtering the dataset.
3.  **Interactive data table:** The table allows users to view the titles of all the movies meeting their filtering criteria, as well as a variety of information about each movie. Users can search for specific keywords and sort by ascending or descending values in each column.
4.  **Download button:** If users would like to attain even more comprehensive information about the dataset, they can download the unprocessed/unfiltered data as a csv file.
5.  **Text Display:** When changing filtering criteria, a text message at the top of the page will update the user on how many different movies are in the filtered dataset.
6.  **Image Display:** Users can click on a row in the interactive table to generate an image of the movie cover.

## Link to the app

**Assignment B3 (SteamGames app):** <https://caydenyu.shinyapps.io/SteamGames/>

**Assignment B4 (IMDb1000 app):** <https://caydenyu.shinyapps.io/IMDb1000/>

## Datasets used

**Assignment B3:** The steam_games dataset is part of the [datateachr](https://github.com/UBC-MDS/datateachr) package.

**Assignment B4:** The IMDb1000 app uses data from the "Top 1000 IMDB Dataset". The CSV was uploaded to kaggle.com by user "FernandoGarciaH24". It can be accessed through the link <https://www.kaggle.com/datasets/fernandogarciah24/top-1000-imdb-dataset>.


