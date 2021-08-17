# Import Libraries
library(tidyverse)
library(pROC)

# --- Prepare the dataset and build a classifier

# read the source csv file
reddit <- read.csv("RS_2017-09_filtered70.csv")
reddit <- as_tibble(reddit)

# select the subset of columns of interest
reddit.selection <- select(reddit, brand_safe, num_crossposts, over_18, is_self, is_reddit_media_domain, is_video, stickied, spoiler)

# summarize the data
reddit.selection %>%
  mutate_if(is.character, as.factor) %>%
  summary

# convert chatacter columns to boolean values
reddit.selection <- reddit.selection %>%
  mutate_if(is.character, as.logical)

# split the data in training and testing data sets
reddit.selection <- reddit.selection %>%
  na.omit()

n <- dim(reddit.selection)[1]  
ind <- sample(c(TRUE, FALSE), n, replace=TRUE, prob=c(0.7, 0.3))

reddit.train <- reddit.selection[ind, ]
reddit.test <- reddit.selection[!ind, ]

# select the factors to include in the model
factors <- c("over_18", "is_self", "is_reddit_media_domain", "is_video", "stickied", "spoiler")
formula <- as.formula(paste("brand_safe ~ ", paste(factors, collapse="+")))

# build the base model
reddit.glm_base <- glm(formula, family=binomial(), reddit.train)

summary(reddit.glm_base)

# factor significance
broom::tidy(reddit.glm_base) %>% filter(term != "(Intercept)") %>% arrange(p.value)

# build a new model with num_crossposts as an additional factor
factors <- c("num_crossposts", "over_18", "is_self", "is_reddit_media_domain", "is_video", "stickied", "spoiler")
formula <- as.formula(paste("brand_safe ~ ", paste(factors, collapse="+")))
reddit.glm_crosspost <- glm(formula, family=binomial(), reddit.train)

summary(reddit.glm_crosspost)

# factor significance
broom::tidy(reddit.glm_crosspost) %>% filter(term != "(Intercept)") %>% arrange(p.value)

# model comparison
anova(reddit.glm_base, reddit.glm_crosspost, test="Chisq")

# --- Model/feature selection

# select the top three significant factors
broom::tidy(reddit.glm_base) %>% 
  select(term, p.value) %>% 
  filter(term != "(Intercept)") %>% 
  arrange(p.value) %>%
  head(3)

# build a new model with the 3 selected factors
factors <- c("over_18", "is_self", "is_reddit_media_domain")
formula <- as.formula(paste("brand_safe ~ ", paste(factors, collapse="+")))
reddit.glm_sigcoef <- glm(formula, family=binomial(), reddit.train)

summary(reddit.glm_sigcoef)

# stepwise regression: forward selection
glm.null <- glm(brand_safe ~ 1, data=reddit.train)
step(glm.null, scope=list(upper=glm(brand_safe ~ ., data=reddit.train)), direction="forward")

# function to calculate model performance
test_model <- function(factors, train, test) {
  # build the model
  formula <- as.formula(paste("brand_safe ~ ", paste(factors, collapse="+")))
  glm_model <- glm(formula, family=binomial(), train)
  
  # perform the predictions
  train$prediction <- predict(glm_model, type="response")
  test$prediction <- predict(glm_model, type="response", newdata=test)
  
  # return the formula and AUC value
  return (c(
    paste(factors, collapse="+"),
    round(auc(train$brand_safe, train$prediction), digits=5),
    round(auc(test$brand_safe, test$prediction), digits=5),
    round(glm_model$aic, digits=5)))
}

# compare different models against the baseline
auc_results <- list(
  test_model(c("1"), reddit.train, reddit.test),
  test_model(c("over_18", "is_self", "is_reddit_media_domain"), reddit.train, reddit.test),
  test_model(c("over_18", "is_self", "is_reddit_media_domain", "is_video", "stickied", "spoiler"), reddit.train, reddit.test),
  test_model(c("num_crossposts", "over_18", "is_self", "is_reddit_media_domain", "is_video", "stickied", "spoiler"), reddit.train, reddit.test))

auc_results <- data.frame(matrix(unlist(auc_results), nrow=length(auc_results), byrow=TRUE))
colnames(auc_results) <- c("factors", "train.AUC", "test.AUC", "AIC")

auc_results

# step 1 - select the first variable with the most impact
auc_results <- list(
  test_model(c("num_crossposts"), reddit.train, reddit.test),
  test_model(c("over_18"), reddit.train, reddit.test),
  test_model(c("is_self"), reddit.train, reddit.test),
  test_model(c("is_reddit_media_domain"), reddit.train, reddit.test),
  test_model(c("is_video"), reddit.train, reddit.test),
  test_model(c("stickied"), reddit.train, reddit.test),
  test_model(c("spoiler"), reddit.train, reddit.test))

auc_results <- data.frame(matrix(unlist(auc_results), nrow=length(auc_results), byrow=TRUE))
colnames(auc_results) <- c("factors", "train.AUC", "test.AUC", "AIC")

auc_results %>%
  arrange(desc(train.AUC))

# step 2 - is_self as first variable
auc_results <- list(
  test_model(c("is_self", "num_crossposts"), reddit.train, reddit.test),
  test_model(c("is_self", "over_18"), reddit.train, reddit.test),
  test_model(c("is_self", "is_reddit_media_domain"), reddit.train, reddit.test),
  test_model(c("is_self", "is_video"), reddit.train, reddit.test),
  test_model(c("is_self", "stickied"), reddit.train, reddit.test),
  test_model(c("is_self", "spoiler"), reddit.train, reddit.test))

auc_results <- data.frame(matrix(unlist(auc_results), nrow=length(auc_results), byrow=TRUE))
colnames(auc_results) <- c("factors", "train.AUC", "test.AUC", "AIC")

auc_results %>%
  arrange(desc(train.AUC))

# step 3 - over_18 as second variable
auc_results <- list(
  test_model(c("is_self", "over_18", "num_crossposts"), reddit.train, reddit.test),
  test_model(c("is_self", "over_18", "is_reddit_media_domain"), reddit.train, reddit.test),
  test_model(c("is_self", "over_18", "is_video"), reddit.train, reddit.test),
  test_model(c("is_self", "over_18", "stickied"), reddit.train, reddit.test),
  test_model(c("is_self", "over_18", "spoiler"), reddit.train, reddit.test))

auc_results <- data.frame(matrix(unlist(auc_results), nrow=length(auc_results), byrow=TRUE))
colnames(auc_results) <- c("factors", "train.AUC", "test.AUC", "AIC")

auc_results %>%
  arrange(desc(train.AUC))
