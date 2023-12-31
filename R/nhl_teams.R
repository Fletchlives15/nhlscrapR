#' @importFrom jsonlite fromJSON
#' @import data.table
#' @importFrom janitor clean_names
#' @import dplyr
#' @import tidyr
#'
#' @title Roster Information
#'
#' @description
#' Function that scrapes the NHL API for NHL team information.
#'
#' @rdname get_nhl_teams
#'
#' @export
#'

get_nhl_teams <- function(){

  strt <- Sys.time()

  teams <- data.table(fromJSON("https://api.nhle.com/stats/rest/en/team")$data) |>
  janitor::clean_names() |>
  filter(tri_code != "NHL") |>
  rename(team_id = id) |>
  arrange(franchise_id)

  print(Sys.time()-strt)

  return(teams)

}
