# Quiz 01
setwd("~/code/analyticsx")

small.xy <- data.frame(X=c(8,5,4,5,6,8,9,7,5,7),Y=c(2,3,4,2,5,6,4,4,6,5))
small.xy

b1 <- cov(x=small.xy$X, y=small.xy$Y) / var(x=small.xy$X)
b0 <- mean(small.xy$Y) - b1 * mean(small.xy$X)
                                   
                                   