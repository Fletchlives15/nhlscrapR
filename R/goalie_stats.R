#' @importFrom jsonlite toJSON unbox
#' @import data.table
#' @importFrom janitor clean_names
#' @import dplyr
#' @import purrr
#' @import tidyr

goalie_stats <- function(year_start = 2013, year_end = 2024){

  season_ids <- map_dbl(year_start:year_end, function(x){

    next_year <-  x+1

    seasons <- as.numeric(paste0(x, next_year, sep = ""))

    return(seasons)

  })

  season_ids <- season_ids[season_ids <= 20232024] # needs better logic here so can run on own

  stats <- map_df(1:10, function(x){

    map_df(season_ids, function(y){

      fromJSON(paste0("https://api.nhle.com/stats/rest/en/goalie/summary?limit=",x * 100,"&start=",x * 100 - 99,"&cayenneExp=seasonId=",y))$data

    })
  })

  stats_clean <- stats |>
    janitor::clean_names() |>
    relocate(season_id, team_abbrevs, player_id, goalie_full_name, shoots_catches, .before = 1) |>
    select(-last_name)

  return(stats_clean)

}
