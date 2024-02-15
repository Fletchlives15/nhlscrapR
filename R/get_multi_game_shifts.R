#' @importFrom foreach foreach `%dopar%`
#' @importFrom parallel makeCluster detectCores stopCluster
#' @importFrom doParallel registerDoParallel
#' @importFrom dplyr bind_rows
#'
#'
#' @title Multi Game Shfits
#'
#' @description
#' Function that scrapes the NHL API for shift data for multiple games.
#'
#' @param game_ids string of game IDs
#'
#' @rdname get_multi_game_shifts
#'
#' @export
#'

get_multi_game_shifts <- function(game_ids){

  strt <- Sys.time()

  cl <- makeCluster(detectCores())
  registerDoParallel(cl)

  shifts <- foreach(i = game_ids, .combine=bind_rows, .multicombine = TRUE,
                    .errorhandling = 'remove', .export = c("get_game_shifts"),
                    .packages = c("jsonlite", "data.table", "janitor", "tidyr")) %dopar%
    {get_game_shifts(i)}

  print(Sys.time()-strt)

  stopCluster(cl)

  return(shifts)
}
