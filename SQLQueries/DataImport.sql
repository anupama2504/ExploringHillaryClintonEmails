create database Hillary_Emails;
use Hillary_Emails;

create table aliases
(Id varchar primary key,
Aliase varchar(200),
PersonId varchar(10)
)

bulk insert aliases
from 'E:\SelfLearn\HillaryClinton_Kaggle\Aliases.csv'
with
(
firstrow = 2,
rowterminator = '\n',
fieldterminator = ','
);
select * from aliases;

create table EmailReceivers
(Id varchar(10) primary key,
EmailId varchar(10),
PersonId varchar(100)
)

bulk insert EmailReceivers
from 'E:\SelfLearn\HillaryClinton_Kaggle\EmailReceivers.csv'
with
(
firstrow = 2,
rowterminator = '\n',
fieldterminator = ','
)

select * from EmailReceivers;


create table Persons
(Id varchar(10) primary key,
FName varchar(100)
)
select * from Persons;

bulk insert Persons
from 'E:\SelfLearn\HillaryClinton_Kaggle\Persons.csv'
with
(
firstrow = 2,
rowterminator = '\n',
fieldterminator = ','
);

select * from Persons;

drop table Emails;
create table Emails
(
Id varchar(10) Primary Key,
DocNumber varchar(100),
MetadataSubject	varchar(100),
MetadataTo varchar,
MetadataFrom varchar,
SenderPersonId varchar,
MetadataDateSent varchar,
MetadataDateReleased varchar,
MetadataPdfLink varchar,
MetadataCaseNumber varchar,
MetadataDocumentClass varchar,
ExtractedSubject varchar,
ExtractedTo varchar,
ExtractedFrom varchar,
ExtractedCc varchar,
ExtractedDateSent varchar,
ExtractedCaseNumber varchar,
ExtractedDocNumber varchar,
ExtractedDateReleased varchar,
ExtractedReleaseInPartOrFull varchar,
ExtractedBodyText varchar,
RawText varchar
)

bulk insert Emails
from 'E:\SelfLearn\HillaryClinton_Kaggle\Emails.csv'
with
(
firstrow = 2,
rowterminator = '\n',
fieldterminator = ','
)
select * from Emails;