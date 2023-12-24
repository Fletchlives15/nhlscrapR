#' @importFrom jsonlite fromJSON
#' @import data.table
#' @importFrom janitor clean_names
#' @import dplyr
#' @import tidyr

nhl_teams <- function(){


  teams <- data.table(fromJSON("https://api.nhle.com/stats/rest/en/team")$data) |>
  janitor::clean_names() |>
  filter(tri_code != "NHL")

  return(teams)

}
