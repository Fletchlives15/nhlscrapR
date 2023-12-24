#' @importFrom jsonlite fromJSON
#' @import data.table
#' @importFrom janitor clean_names
#' @import dplyr
#' @import purrr
#' @import tidyr

skater_stats <- function(year_start = 2013, year_end = 2024){

  season_ids <- map_dbl(year_start:year_end, function(x){

    next_year <-  x+1

    seasons <- as.numeric(paste0(x, next_year, sep = ""))

    return(seasons)

  })

  end_season_id <- as.numeric(paste0(year_end - 1, year_end, sep = "")) # last season id in function

  season_ids <- season_ids[season_ids <= end_season_id] # needs better logic here so can run on own

  stats <- map_df(1:10, function(page){

      map_df(season_ids, function(season){

        fromJSON(paste0("https://api.nhle.com/stats/rest/en/skater/summary?limit=",page * 100,"&start=",page * 100 - 99,"&cayenneExp=seasonId=",season))$data

     })
  })

  stats_clean <- stats |>
    janitor::clean_names() |>
    relocate(season_id, team_abbrevs, player_id, skater_full_name, position_code, shoots_catches, .before = 1) |>
    select(-last_name)

    return(stats_clean)

}
