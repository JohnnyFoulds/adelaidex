# Import Libraries
library(tidyverse)
library(lubridate)
library(tidytext)
library(tm)
library(SnowballC)

# --- Reading in the data and basic data cleaning
reddit <- read.csv("RS_2017-09_filtered70.csv", stringsAsFactors=TRUE)
reddit <- as_tibble(reddit)
reddit

# remove the first column
reddit <- select(reddit, -X)
reddit

# identify columns with no data
reddit.is_empty <- reddit %>%
  apply(
    MARGIN=2,
    FUN=function(x) all(is.na(x))) %>%
  data.frame

colnames(reddit.is_empty)[1] <- "empty"

reddit.is_empty %>%
  filter(empty == TRUE)

# remove empty columns
reddit <- reddit[, !sapply(reddit, function(x) all(is.na(x))), drop=FALSE]
reddit

# identify columns with a single value
reddit %>% 
  select_if(~n_distinct(.) == 1) %>%
  head(1)

# remove columns with a single value
reddit <- reddit %>% 
  select_if(~n_distinct(.) > 1)

reddit

# convert created_utc and retrieved_on to abbreviated week day names
reddit <- reddit %>%
  mutate(created_utc = as.POSIXct(created_utc, origin = "1970-01-01"))  %>%
  mutate(retrieved_on = as.POSIXct(retrieved_on, origin = "1970-01-01")) %>%
  mutate(created_utc = wday(created_utc, label=TRUE, abbr=TRUE))  %>%
  mutate(retrieved_on = wday(retrieved_on, label=TRUE, abbr=TRUE))

# convert the columns to factors
reddit$created_utc <- factor(reddit$created_utc)
reddit$retrieved_on <- factor(reddit$retrieved_on)

# summarize created_utc
reddit %>%
  select(created_utc) %>%
  group_by(created_utc) %>%
  summarise(freq=n())

# summarize retrieved_on
reddit %>%
  select(retrieved_on) %>%
  group_by(retrieved_on) %>%
  summarise(freq=n())

# --- Text processing of the titles

# clean the titles for processing
docs <- Corpus(VectorSource(pull(reddit, title)))

docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, content_transformer(function(x) gsub(x, pattern = "–", replacement = " ")))
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, stemDocument)

# get the document term matrix and convert it to an incidence matrix
dtm <- TermDocumentMatrix(docs)
dtm$v <-rep(1, length(dtm$v))

# find terms that appears at least in 500 titles
ft <- findFreqTerms(dtm, lowfreq=500)

# filter the document term matrix to only frequent terms
dtm <- dtm[Terms(dtm)%in%ft,]

# convert the dtm to a matrix
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

# display the word frequencies
pull(d, word)

# transpose the matrix and add a column prefix
m <- t(m)
colnames(m) <- paste("title", colnames(m), sep = "_")

#add the incident matrix data to the reddit data frame
reddit <- bind_cols(reddit, as_tibble(m), .name_repair="unique")

# remove the title column
reddit <- select(reddit, -title)

colnames(reddit)

# --- Recoding of factors

# identify factors to recode
factor_cols <- reddit %>%
  select_if(is.factor) %>%  
  gather(name, value) %>% 
  count(name, value) %>%
  filter(n < 30) %>%
  group_by(name) %>%
  summarise() %>%
  pull(name)

factor_cols

# recode the factors found with at least one factor occurring less than 30 times
reddit[factor_cols] <- sapply(reddit[factor_cols], function(x) fct_lump_min(f=x, min=30, other_level="other"))
reddit <- reddit %>% mutate_at(all_of(factor_cols), as.factor)

# identify factors with more than 100 levels
many_factor <- reddit %>%
  select_if(is.factor) %>% 
  sapply(nlevels) %>%
  data.frame() %>%
  rownames_to_column() %>%
  setNames(c("name", "n")) %>%
  filter(n > 100) %>%
  pull(name)

many_factor

# retain only the 100 most commonly occuring levels
reddit[many_factor] <- sapply(reddit[many_factor], function(x) fct_lump_n(f=x, n=100, other_level="other"))
reddit <- reddit %>% mutate_at(all_of(many_factor), as.factor)

# find factors that can't be successfully recoded
removal_factors <- reddit %>%
  select_if(is.factor) %>%  
  gather(name, value) %>% 
  count(name, value) %>%
  filter(n < 30) %>%
  group_by(name) %>%
  summarise() %>%
  pull(name)

removal_factors

# remove factors that could not be recoded
reddit <- reddit %>%
  select(-all_of(removal_factors))

# find factors with only one level
uniform_factors <- reddit %>%
  select_if(is.factor) %>% 
  sapply(nlevels) %>%
  data.frame() %>%
  rownames_to_column() %>%
  setNames(c("name", "n")) %>%
  filter(n == 1) %>%
  pull(name)

uniform_factors

# remove uniform factors
reddit <- reddit %>%
  select(-all_of(uniform_factors))

# --- Additional considerations and important notes

# identify columns with an excessive number of missing values
na_factors <- reddit %>%
  sapply(function(x) sum(length(which(is.na(x))))) %>%
  data.frame() %>%
  rownames_to_column() %>%
  setNames(c("name", "n")) %>%
  filter(n > 20) %>%
  pull(name)

na_factors

# remove factors with excessive NA values
reddit <- reddit %>%
  select(-all_of(na_factors))

# list remaining factors and number of levels
reddit %>%
  select_if(is.factor) %>% 
  sapply(nlevels) %>%
  data.frame() %>%
  rownames_to_column() %>%
  setNames(c("factor", "levels"))

# --- Data transformation

# identify numeric predictor variables
numeric_columns <- reddit %>% 
  select(where(is.numeric)) %>%
  select(-starts_with("title_")) %>%
  names()

numeric_columns

# get the numeric column values to plot
numeric_data <- reddit %>% 
  select(all_of(numeric_columns)) %>%
  gather(key="column", value="value", -score)

# plot the unchanged numeric values against score
ggplot(numeric_data, aes(x=value, y=score)) + 
  stat_bin_hex(bins=10) + 
  scale_fill_continuous(low="#B6D191", high="darkgreen") +
  geom_smooth(method='lm', color="darkgray") +
  facet_wrap(~column, scales="free")

# transform the numeric values
scale <- function(x) log(1 + x)

scaled_data <- numeric_data %>%
  mutate_if(is.numeric, scale)

# plot the scaled numeric values against score
ggplot(scaled_data, aes(x=value, y=score)) + 
  stat_bin_hex(bins=10) +
  scale_fill_continuous(low="#B6D191", high="darkgreen") +
  geom_smooth(method='lm', color="darkgray") +
  facet_wrap(~column, scales="free")

# transform the numeric values in the data set
reddit <- reddit %>% mutate_at(all_of(numeric_columns), scale)

# --- Assumptions and summary

# fit a linear regression using all the columns in the data frame
reddit.lm <- lm(score~.,data=reddit)

# basic model summary
glance(reddit.lm) %>% gather()

# diagnostic plots
layout(matrix(c(1,2,3,4),2,2))
plot(reddit.lm)

# --- Aliased factors

# get a list of the factor names
factor_names <- reddit %>%
  select_if(is.factor) %>%
  names()

# function to match aliased coefficient back to original factor
find_match <- function(value, list) {
  for (i in nchar(value):1) {
    current_value = substr(value, 1, i)
    if (current_value %in% list) {
      return(current_value)
    }
  }
  
  return(NA)
}

# find coefficients with no value
term_list <- names(coef(reddit.lm))[is.na(coef(reddit.lm))]

# match coefficients labels to factors
term_list <- as_tibble(term_list)
term_list$variable <- mapply(find_match, term_list$value, MoreArgs=list(list=factor_names))

# get a list of the redundant variables
redundant_variables <- unique(term_list$variable)
redundant_variables

# remove redundant variables
update_formula <- as.formula(
  paste(". ~ . -", 
  paste(redundant_variables, collapse=" -"), sep=""))

reddit.lm <- update(reddit.lm, update_formula)

# --- Simplification of the model

# unchanged model
reddit.lm %>% glance %>% gather

# without author_cakeday
update(reddit.lm, . ~ . -author_cakeday)  %>% glance %>% gather

# without contest_mode
update(reddit.lm, . ~ . -contest_mode)  %>% glance %>% gather

# without author_cakeday and contest_mode
update(reddit.lm, . ~ . -author_cakeday -contest_mode)  %>% glance %>% gather

# remove the variables from the model
reddit.lm <- update(reddit.lm, . ~ . -author_cakeday -contest_mode)
