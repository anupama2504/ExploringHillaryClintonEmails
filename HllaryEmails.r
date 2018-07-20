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
library(RSQLite)
con <- dbConnect(drv = RSQLite::SQLite(), dbname = 'database.sqlite')
tables <- dbListTables(con)
