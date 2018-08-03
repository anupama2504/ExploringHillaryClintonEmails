setwd('E:\\SelfLearn\\HillaryClinton_Kaggle')
Aliases <- read.csv('Aliases.csv')
View(Aliases)
table(is.na(Aliases))

EmailReceivers <- read.csv('EmailReceivers.csv')
table(is.na(EmailReceivers))

Persons <- read.csv('Persons.csv')
Emails <- read.csv('Emails.csv')
colnames(Emails)
summary(Emails)
typeof(Emails)
str(Emails)

Email_text <- as.list(Emails$RawText)
typeof(Email_text)
head(Email_text)

#-----------------------------SQL LITE--------------------------
install.packages("RSQLite")
install.packages("sqldf")
library(RSQLite)
library(sqldf)

#create SQLite db connection
con <- dbConnect(drv = RSQLite::SQLite(), dbname = 'database.sqlite')

#storing database tables
tables <- dbListTables(con)


#querying data into the tables

myTableDF <- vector("list", length = length(tables))
for (i in seq(along=tables)) {
  myTableDF[[i]] <- dbGetQuery(conn = con, statement = paste("SELECT * FROM" , tables[[i]]) )
}
tables
Aliases <- as.data.frame(myTableDF[1])
EmailReceivers<- as.data.frame(myTableDF[2])
Emails <- as.data.frame(myTableDF[3])
Persons <- as.data.frame(myTableDF[4])

summary(Emails)
summary(Persons)


#who sent most emails?
SenderEmailCount <- sqldf("Select p.Name, count(p.Name) EmailsSent from Emails e inner join Persons p on e.SenderPersonId = p.Id
      Group By p.Name Order by count(p.Name) DESC Limit 10")
summary(SenderEmailCount)



library(ggplot2)
ggplot(SenderEmailCount, aes(x=reorder(Name, EmailsSent), y=EmailsSent)) +
  geom_bar(stat="identity", fill="Green") +
  coord_flip() + 
  theme_light(base_size=16) +
  xlab("") +
  ylab("Number of Emails Sent") + 
  theme(plot.title=element_text(size=14))


write.table(Emails$RawText, file = "EmailText.txt", sep = '\n', row.names = FALSE)


#----------------Wordcloud of Hillary's Emails------------- reference from https://www.kaggle.com/benhamner/exploring-hillary-clinton-s-emails
EmailsFromHillary <- sqldf("SELECT p.Name Sender,
       ExtractedBodyText EmailBody
FROM Emails e
INNER JOIN Persons p ON e.SenderPersonId=P.Id
WHERE p.Name='Hillary Clinton'
  AND e.ExtractedBodyText != ''
ORDER BY RANDOM()")


library(tm)
library(wordcloud)
makeWordCloud <- function(documents) {
  corpus = Corpus(VectorSource(tolower(documents)))
  corpus = tm_map(corpus, removePunctuation)
  corpus = tm_map(corpus, removeWords, stopwords("english"))
  
  frequencies = DocumentTermMatrix(corpus)
  word_frequencies = as.data.frame(as.matrix(frequencies))
  
  words <- colnames(word_frequencies)
  freq <- colSums(word_frequencies)
  wordcloud(words, freq,
            min.freq=sort(freq, decreasing=TRUE)[[100]],
            colors=brewer.pal(8, "Dark2"),
            random.color=TRUE)  
}

makeWordCloud(EmailsFromHillary[["EmailBody"]])



#---------------------Counting word frequency using dictionary------------------
text <- Emails$RawText
install.packages('dplyr')
allCountryNames <- tolower(scan('countries.txt', what = 'character', comment.char = ';' ))
countryCounter<- rep(0, length(allCountryNames))
names(countryCounter) <- allCountryNames


final <- country.count(text, .progress = 'text')

country.count <- function(emails, .progress='none')
{
  require(dplyr)
  require(stringr)
  countryMentioned <- laply(emails, function(email){
    email <- gsub('[[:punct:]]', "", email)
    email <- gsub('[[:cntrl:]]', "", email)
    email <- gsub('\\d+', "", email)
    email <- tolower(email)
    word.list <- str_split(email, '\\s+')
    words_unlist <- unlist(word.list)
    for (i in 1:length(words_unlist)) {
     if (is.na(match(words_unlist[i],allCountryNames))) {
       
     }
      else if (match(words_unlist[i],allCountryNames)>0) {
        countryCounter[words_unlist[i]]= countryCounter[words_unlist[i]]+1
     } 
    }
    return(countryCounter)
  }, .progress = .progress)
  return(countryCounter)
}



#---------------TEXT MINING------------ refering to http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know#step-3-text-mining

install.packages("tm")
install.packages("tidytext")
install.packages("wordcloud")
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")


text<- readLines("EmailText.txt")

text1 <- as.data.frame(text)
docs <- Corpus(VectorSource(text))
inspect(docs)

#creating a function to replace special characters with space
toSpace <- content_transformer(function(x,pattern) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace,'([.])|[[:punct:]]')
docs <- tm_map(docs, toSpace, '[[:cntrl:]]')
docs <- tm_map(docs,removeNumbers)
docs <- tm_map(docs, removeWords,stopwords('english'))

