test_that("It pulls all stats", {

  tester <- get_goalie_stats(2015,2023)

  expect_equal(get_goalie_stats(2015,2023), tester)
})
