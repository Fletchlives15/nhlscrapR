test_that("games pull", {
  tester <- get_game_info(2022,2023)

  expect_equal(get_game_info(2022,2023), tester)
})
