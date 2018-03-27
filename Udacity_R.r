
#https://www.kaggle.com/tammyrotem/ab-tests-with-python

library(readr)
control<- read_csv("//prc-cs-f9dkb42/ecozzolino$/Desktop/code/AB Test Library/control_data.csv")
experiment<- read_csv("//prc-cs-f9dkb42/ecozzolino$/Desktop/code/AB Test Library/experiment_data.csv")

library(plyr)

t.test(control$Pageviews, experiment$Pageviews)
#p = 0.887, ns difference
t.test(control$Clicks, experiment$Clicks)
#p = 0.9264, ns difference
t.test(control$Enrollments, experiment$Enrollments)
#p = 0.098, marginally sig
t.test(control$Payments, experiment$Payments)
#p = 0.5564, ns difference

