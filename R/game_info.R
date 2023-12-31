#' @importFrom jsonlite fromJSON
#' @import data.table
#' @importFrom janitor clean_names
#' @import dplyr
#' @import tidyr
#' @importFrom lubridate ymd_hms
#'
#' @title Game Information
#'
#' @description
#' Function that scrapes the NHL API for game information between specified years.
#'
#' @param year_start First desired year to scrape from in YYYY format.
#' @param year_end Last desired year to scrape to in YYYY format.
#'
#' @rdname get_game_info
#'
#' @export
#'

### function to pull games between seasons
## game type 1 = preseason, 2 = reg season, 3 = post season
get_game_info <- function(year_start, year_end){

  strt <- Sys.time()

  start_season_id <- as.numeric(paste0(year_start, year_start + 1, sep = "")) # first season id in function
  end_season_id <- as.numeric(paste0(year_end - 1, year_end, sep = "")) # last season id in function

  games <- data.table(fromJSON("https://api.nhle.com/stats/rest/en/game")$data) |>
    janitor::clean_names()

  ## filtering of seasons played
  # filters seasons between start and end.
  games_filt <- games |>
    filter(dplyr::between(season, start_season_id, end_season_id),
           game_type <= 3) |>
    rename(game_id = id, season_id = season) |>
    mutate(eastern_start_time = ymd_hms(eastern_start_time)) |>
    relocate(season_id, .after = game_id) |>
    relocate(period, .after = visiting_score)

  print(Sys.time() - strt)

  return(games_filt)

}
