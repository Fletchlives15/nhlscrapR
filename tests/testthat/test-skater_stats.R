test_that("skaters pull", {
  tester <- get_skater_stats(2019,2023)

  expect_equal(get_skater_stats(2019,2023), tester)
})
