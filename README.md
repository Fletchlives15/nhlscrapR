
# nhlscrRaper

<!-- badges: start -->
<!-- badges: end -->

The goal of nhlscrRaper is to allow someone to scrape data from the NHL API to be used in analysis. Currently, functions pull rosters, skater/goalie summary stats, team information, game information, and event data for single game or full date range (specified through game ids).

## Installation

You can install the development version of nhlscrRaper from [GitHub](https://github.com/) with:

1. If not already downloaded: `install.packages("devtools")`
2. To install the package run: `devtools::install_github("Fletchlives15/nhlscRaper")`
3. Lastly, `library(nhlscRaper)`

## Functions

**Team and roster information:**

1. call teams. `teams <- nhl_teams()`
2. select which team or teams you want. `det_rw <- teams[team_id == 17][,tri_code]`
3. Input years you want. `players <- roster_info(team_tricode = det_rw, year_start = 2022, year_end = 2023)`

If you want all players for a specific year you can leave "team_tricode" empty and just call years.


**Summary skater/goalie stats:**

If you just want summary stats for a year all you need to do is specify the years you want. 

`skater <- skater_stats(year_start = 2022, year_end = 2023)`

`goalies <- goalie_stats(year_start = 2022, year_end = 2023)`

**Event Data:**

*Single Game:*

1. Find games for the specified years. `games <- game_info(year_start = 2022, year_end = 2023)`
2. Pull specific game id. `game_id <- games[,game_id[1]]`
3. Run function. `one_game_events <- game_events(game_id = game_id)`

*Multiple Games:*

1. Find games for the specified years. `games <- game_info(year_start = 2022, year_end = 2023)`
2. Pull game ids. `game_ids <- games[,game_id]`
3. Run function. `multi_game_events <- all_game_events(game_ids = game_ids)`


