#' @importFrom jsonlite fromJSON
#' @import data.table
#' @importFrom janitor clean_names
#' @import dplyr
#' @import purrr
#' @import tidyr
#'
#' @title Roster Information
#'
#' @description
#' Function that scrapes the NHL API for team rosters between specified years for specified teams.
#'
#' @param team_tricode Three letter code that specifies which team you would like to pull data for.
#' @param year_start First desired year to scrape from.
#' @param year_end Last desired year to scrape to.
#'
#' @rdname roster_info
#'
#' @export
#'

get_roster_info <- function(team_tricode = c("ATL", "HFD", "MNS", "QUE", "WIN", "CLR", "SEN", "HAM", "PIR", "QUA", "DCG",
                                         "MWN", "QBD", "MMR", "NYA", "SLE", "OAK", "AFM", "KCS", "CLE", "DFL", "BRK",
                                         "NJD", "CGS", "TAN", "TSP", "DET", "BOS", "WPG", "SJS", "PIT", "TBL", "PHI",
                                         "TOR", "BUF", "CAR", "ARI", "CGY", "MTL", "WSH", "LAK", "VAN", "COL", "NSH",
                                         "ANA", "VGK", "NYI", "SEA", "DAL", "PHX", "CHI", "NYR", "CBJ", "FLA", "EDM",
                                         "MIN", "STL", "OTT"),
                        year_start,
                        year_end){

  strt <- Sys.time()

  ### Pull Togethers
  ## Team set ups for rosters
  # pulls from API for teams
  teams <- data.table(fromJSON("https://api.nhle.com/stats/rest/en/team")$data) |>
    janitor::clean_names() |>
    filter(tri_code != "NHL") |> # Filter out "NHL" since it does not have a season_id
    filter(tri_code %in% team_tricode)

  teams_pull <- teams[, tri_code] # Pull out tri code for seasons map

  ## seasons played for each team
  # pulls from roster-season to get years that team has played in NHL
  season_played <- map_df(teams_pull, function(team_abbrev){

    team_season <- fromJSON(paste0("https://api-web.nhle.com/v1/roster-season/",team_abbrev))

    return(data.table(team = team_abbrev,
                      season_id = as.numeric(team_season)))

  })

  ## season id paste together
  # joining start and end years to get season ids. must be numeric for filtering
  start_season_id <- as.numeric(paste0(year_start, year_start + 1, sep = "")) # first season id in function
  end_season_id <- as.numeric(paste0(year_end - 1, year_end, sep = "")) # last season id in function

  ## filtering of seasons played
  # filters seasons between start and end.
  season_played_filt <- season_played |>
    filter(dplyr::between(season_id, start_season_id, end_season_id))

  ## pulling together of rosters of each team for each season
  player_info <- map_df(unique(season_played_filt$team), function(team_abbrev){

    season_ids <- season_played_filt[team %in% team_abbrev][,season_id] # pulling season ids for each team

    map(season_ids, function(year_id){

      roster <- fromJSON(paste0("https://api-web.nhle.com/v1/roster/",team_abbrev,"/",year_id))

      ## Need to split up json then join later
      # forwards
      forwards <- roster$forwards |>
        select(-where(is.list)) |>
        bind_cols(roster$forwards$firstName$default) |>
        bind_cols(roster$forwards$lastName$default)

      # defensemen
      defensemen <- roster$defensemen |>
        select(-where(is.list)) |>
        bind_cols(roster$defensemen$firstName$default) |>
        bind_cols(roster$defensemen$lastName$default)

      # goalies
      goalies <- roster$goalies |>
        select(-where(is.list)) |>
        bind_cols(roster$goalies$firstName$default) |>
        bind_cols(roster$goalies$lastName$default)

      ## join all together and rename player id column
      year_roster <- full_join(forwards, defensemen) |>
        full_join(goalies) |>
        janitor::clean_names() |>
        rename(player_id = id)

      # rename united player first name and last name columns
      year_roster_rename <- year_roster |>
        unite(col = "full_name", x12, x13, sep = " ") |>
        relocate(full_name, .before = headshot)

      # return data.table with team abbrev, season_id for that year, and then the player details
      return(data.table(team = team_abbrev,
                      season_id = year_id,
                      year_roster_rename))

    })

  })

  print(Sys.time()-strt)

  # return the player info
  return(player_info)

}
