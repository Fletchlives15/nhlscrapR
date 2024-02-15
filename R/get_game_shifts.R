#' @importFrom jsonlite fromJSON
#' @importFrom data.table data.table
#' @importFrom janitor clean_names
#' @importFrom tidyr unite
#'
#' @title Game Shifts
#'
#' @description
#' Function that scrapes NHL API for single game event data.
#'
#' @param game_id ID for single game
#'
#' @rdname get_game_shifts
#'
#' @export
#'

get_game_shifts <- function(game_id){

  strt <- Sys.time()

  # last season id in function

  game_list <- fromJSON(paste0("https://api.nhle.com/stats/rest/en/shiftcharts?cayenneExp=gameId=",game_id,"%20and%20((duration%20!=%20%2700:00%27%20and%20typeCode%20=%20517)%20or%20typeCode%20!=%20517%20)&exclude=id&exclude=hexValue&exclude=detailCode&exclude=eventDescription&exclude=eventDetails&exclude=teamAbbrev&exclude=teamName"),
                        flatten = TRUE)

  shift_data <- game_list$data |>
    janitor::clean_names() |>
    unite("full_name", first_name, last_name, sep = " ")

  return(shift_data)

}
