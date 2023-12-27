#' @import doParallel
#' @import parallel
#'
#' @export
#'

all_game_events <- function(game_ids){

  strt <- Sys.time()

  cl <- makeCluster(detectCores())
  registerDoParallel(cl)

  events <- foreach(i = game_ids, .combine=bind_rows, .multicombine = TRUE,
                          .errorhandling = 'remove', .export = c("game_events"),
                          .packages = c("jsonlite", "data.table", "janitor")) %dopar%
    {game_events(i)}

  print(Sys.time()-strt)

  stopCluster(cl)

  return(events)
}
