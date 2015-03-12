# test data; from ?CausalImpact help
set.seed(1)
x1 <- 100 + arima.sim(model = list(ar = 0.999), n = 100)
y <- 1.2 * x1 + rnorm(100)
y[71:100] <- y[71:100] + 10

data <- data.frame(y=y, x=x1, date=as.Date("2015-01-01"):as.Date("2015-04-10"))
write.table(data, file="testData.csv", sep=";", col.names=T, row.names = F)
