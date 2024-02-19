#' @importFrom foreach foreach `%dopar%`
#' @importFrom parallel makeCluster detectCores stopCluster
#' @importFrom doParallel registerDoParallel
#' @importFrom dplyr bind_rows
#'
#'
#' @title Multi Game Events
#'
#' @description
#' Function that scrapes the NHL API for roster data for multiple games.
#'
#' @param game_ids string of game IDs
#'
#' @rdname get_multi_game_events
#'
#' @export
#'

get_multi_game_rosters <- function(game_ids){

  strt <- Sys.time()

  cl <- makeCluster(detectCores())
  registerDoParallel(cl)

  rosters <- foreach(i = game_ids, .combine=bind_rows, .multicombine = TRUE,
                    .errorhandling = 'remove', .export = c("get_game_roster"),
                    .packages = c("jsonlite", "data.table", "janitor", "dplyr")) %dopar%
    {get_game_roster(i)}

  print(Sys.time()-strt)

  stopCluster(cl)

  return(rosters)
}
