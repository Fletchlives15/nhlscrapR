#' @importFrom jsonlite fromJSON
#' @importFrom data.table data.table
#' @importFrom janitor clean_names
#' @importFrom dplyr relocate select arrange between where
#' @importFrom purrr map map_dbl
#'
#' @title Goalie Stats
#'
#' @description
#' Function that scrapes the NHL API for goalie statistics between specified years.
#'
#' @param year_start First desired year to scrape from in YYYY format.
#' @param year_end Last desired year to scrape to in YYYY format.
#'
#' @rdname get_goalie_stats
#'
#' @export
#'

get_goalie_stats <- function(year_start, year_end){

  strt <- Sys.time()

  season_ids <- map_dbl(year_start:year_end, function(x){

    next_year <-  x+1

    seasons <- as.numeric(paste0(x, next_year, sep = ""))

    return(seasons)

  })

  end_season_id <- as.numeric(paste0(year_end - 1, year_end, sep = "")) # last season id in function

  season_ids <- season_ids[season_ids <= end_season_id] # filters out last season

  stats <- map_df(1:10, function(page){

    map_df(season_ids, function(season){

      fromJSON(paste0("https://api.nhle.com/stats/rest/en/goalie/summary?limit=",page * 100,"&start=",page * 100 - 99,"&sort=playerId&cayenneExp=seasonId=",season))$data

    })
  })

  stats_clean <- stats |>
    janitor::clean_names() |>
    relocate(season_id, team_abbrevs, player_id, goalie_full_name, shoots_catches, .before = 1) |>
    select(-last_name) |>
    arrange(season_id, player_id, team_abbrevs)

  print(Sys.time()-strt)

  return(stats_clean)

}
