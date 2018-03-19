#Bayesian A/B testing: https://www.r-exercises.com/2017/08/21/bayesian_ab_testing_made_easy/

#A = existing website
#B = new website

#H0 = beta dist w/ mean 0.5
#simulate 20 obvs for each group & compare probabilities 
control_1 <- rbinom(20, 1, 0.5)
treatment_1 <- rbinom(20, 1, 0.3)

install.packages("bayesAB")
library("bayesAB")

test1 <- bayesTest(treatment_1, control_1, distribution = "bernoulli", priors = c("alpha" = 10, "beta" = 10))
print(test1)
summary(test1)
plot(test1)

#additional 20 obvs
control_2 <- rbind(control_1, rbinom(20, 1, 0.5))
treatment_2 <- rbind(treatment_1, rbinom (20, 1, 0.3))

test2 <- bayesTest (treatment_2, control_2, distribution = "bernoulli", priors = c("alpha" = 10, "beta" = 10))
print(test2)
summary(test2)
plot(test2)
