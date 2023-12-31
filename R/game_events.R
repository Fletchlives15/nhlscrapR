#' @importFrom jsonlite fromJSON
#' @import data.table
#' @importFrom janitor clean_names
#'
#' @title Game Events
#'
#' @description
#' Function that scrapes NHL API for single game event data.
#'
#' @param game_id ID for single game
#'
#' @rdname get_game_events
#'
#' @export
#'


get_game_events <- function(game_id){

  strt <- Sys.time()

  # last season id in function

  game_list <- fromJSON(paste0("https://api-web.nhle.com/v1/gamecenter/",game_id,"/play-by-play"),
                        flatten = TRUE)

  play_data <- game_list$plays |>
    janitor::clean_names()

  home_team <- data.table(home_tri_code = game_list$homeTeam$abbrev,
                          home_team_id = game_list$homeTeam$id)
  away_team <- data.table(away_tri_code = game_list$awayTeam$abbrev,
                          away_team_id = game_list$awayTeam$id)

  print(Sys.time() - strt)

  return(data.table(game_id,
                    home_team,
                    away_team,
                    play_data))

}
