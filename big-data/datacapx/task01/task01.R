# Import Libraries
library(tidyverse)
library(lubridate)
library(tidytext)
library(tm)
library(SnowballC)

# --- Reading in the data and basic data cleaning
reddit <- read.csv("RS_2017-09_filtered70.csv")
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
