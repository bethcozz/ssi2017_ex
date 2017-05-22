source('silly_function.R')

context("Silly Tests")

test_that('returns a numeric',{
  expect_true(is.numeric(sillyFunction(1,2)))
  expect_type(sillyFunction(100,-203),"double")
})

test_that('not equal to a+b',{
  expect_false(sillyFunction(1,2)==3)
})
