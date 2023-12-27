
# nhlscrRaper

<!-- badges: start -->
<!-- badges: end -->

The goal of nhlscrRaper is to allow someone to scrape data from the NHL API to be used in analysis. Currently, functions pull rosters, skater/goalie summary stats, team information, game information, and event data for single game or full date range (specified through game ids).

## Installation

You can install the development version of nhlscrRaper from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Fletchlives15/nhlscRaper")
```

## Functions

List of functions and usage:

``` r
# To pull teams and roster information:
teams <- nhl_teams()
det_rw <- teams[team_id == 17][,tri_code]
players <- roster_info(team_tricode = det_rw, year_start = 2022, year_end = 2023)
```

``` r
# To pull summary skater/goalie stats:
skater <- skater_stats <- goal
goalies <- goalie_stats(year_start = 2022, year_end = 2023)

```

``` r
# To pull event data:
games <- game_info(year_start = 2022, year_end = 2023) 
game_id <- games[,game_id[1]]
one_game_events <- game_events(game_id = game_id)

# To pull multiple games:
games <- game_info(year_start = 2022, year_end = 2023) 
game_ids <- games[,game_id]
multi_game_events <- all_game_events(game_ids = game_ids)
```

