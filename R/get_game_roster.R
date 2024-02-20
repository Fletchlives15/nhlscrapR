#' @importFrom jsonlite fromJSON
#' @importFrom data.table data.table
#' @importFrom janitor clean_names
#' @importFrom dplyr select
#'
#' @title Game Roster
#'
#' @description
#' Function that scrapes NHL API for single game roster data.
#'
#' @param game_id ID for single game
#'
#' @rdname get_game_roster
#'
#' @export
#'


get_game_roster <- function(game_id){

  strt <- Sys.time()

  # last season id in function

  game_list <- fromJSON(paste0("https://api-web.nhle.com/v1/gamecenter/",game_id,"/play-by-play"),
                        flatten = TRUE)

  roster_data <- game_list$rosterSpots |>
    janitor::clean_names() |>
    select(team_id, player_id, position_code)

  print(Sys.time() - strt)

  return(data.table(game_id,
                    roster_data))

}
