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
