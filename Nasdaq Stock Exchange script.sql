
----- creating the database-----
USE master
GO

IF EXISTS(SELECT * FROM SYS.DATABASES WHERE NAME = 'Nasdaq')
DROP DATABASE Nasdaq
GO

CREATE DATABASE Nasdaq
GO

-----Using the new data base------
USE Nasdaq
GO

--------------------Creating tables---------------------------

CREATE TABLE Brokers 
(
BrokerID int identity (1,1) constraint br_pk Primary Key,
BrokerName varchar(30) not null,
DateOfJoining date,
IsActive BIT not null, ---0 false, 1 true ---
LastRegulatoryAuditDate date not null,
Country varchar(50),
City varchar(50),
Adress nvarchar(60),
BrokerRate smallint,
IsGlobal bit
);
Go



CREATE TABLE AccountHolders
(
InvestorID int identity (1,1) constraint ac_pk Primary Key,
NationalID int not null,
BrokerID int foreign key references Brokers(BrokerID),
FirstName varchar(15) not null,
LastName varchar(30),
Adress nvarchar(60),
Phone nvarchar(20)   not null constraint Uq_tel unique,
Email varchar(60) constraint ck_Email_has_@  check(email like '%@%.%' ),
TotalAssets money,
Nationality varchar(60)
);
Go



CREATE TABLE Stocks
(
ISIN int identity (1,1) constraint stocks_pk Primary Key,
Name varchar(30) not null,
TypeOfAsset varchar(30) constraint ck_AssetType_valid  check(TypeOfAsset in('Bond','Stock', 'ETF', 'MTF')) ,
MarketPrice money not null,
ExpenseRatio real default(0),
DividenedDistribution nvarchar(60) constraint ck_DD_yqm check(DividenedDistribution in('Y','Q','M', null) ),
inIndex varchar(50) not null,
MarketSizeCap char constraint ck_MarketSize  check(MarketSizeCap in('L','M','S','B')),
Sector varchar(30),
NumberOfStocks int not null constraint ck_num_of_stocks check(NumberOfStocks > 0)
);
Go


CREATE TABLE Orders
(
OrderID int identity (1,1) constraint Orders_pk Primary Key,
StockISIN int foreign key references Stocks(ISIN) not null,
BuyOrSell varchar(4)  constraint BuyOrSell_ck_ifvalid check(BuyOrSell in ('Buy','Sell')), 
OrderType varchar(20) not null  constraint CK_OT_Valid check(OrderType in('Limit', 'StopLimit', 'Market', 'Short')),
TimeOfSubbmition datetime,
IsActive  VARCHAR(2) constraint IsActive_ck_ifvalid check(IsActive in ('Y','N')), 
OrderStatus varchar(50) not null constraint CK_OS_Valid check(OrderStatus in ('Pending','Done','Partly done', 'Cancelled', 'Updated')),
InvestorId int foreign key references AccountHolders(InvestorID) not null,
Price money null,
Quantity int not null
);
Go


CREATE TABLE Transactions
(
TransactionID int identity (1,1) constraint Trans_pk Primary Key,
FirstOrderID int foreign key references Orders(OrderID) not null,
SecondOrderID int foreign key references Orders(OrderID) not null,
Quantity int not null,
Price money not null,
TimeOfTransaction datetime,
TranStatus varchar(50) not null constraint CK_TranStat_Valid check(TranStatus in ('Preforming','Done', 'Cancelled')),
IsSecured  VARCHAR(2) constraint CK_Tran_Sec check(IsSecured in ('Y','N')) not null,
SecurityCode VARCHAR(10) not null,
Comments  VARCHAR(50)   default null

);
Go



--------Intserting values into the tables----------

INSERT INTO Brokers([BrokerName],[DateOfJoining],[IsActive],[LastRegulatoryAuditDate],[Country],[City],[Adress],[BrokerRate],[IsGlobal]) 
VALUES('Wayne','01/08/1996','1','02/15/2002','Saint Vincent and The Grenadines','Montignies-sur-Sambre','Ap #985-6330 Imperdiet Rd.',1,'1' ),
('Leumi','04/15/2003','1','08/26/2000','Israel','Tel Aviv','Rotschild 128',2,'0'),
('eToro','10/16/2017','1','04/17/2011','Israel','Beuzet','1960 Tincidunt. Road',4,'1'),
('Trade Nation','11/22/2018','0','03/05/2009','Falkland Islands','Navsari','P.O. Box 145, 8380 Nam Road',3,'1'),
('Saxo Capital Markets','07/18/2005','1','04/17/2004','Nauru','Bensheim','Ap #546-9495 Est Av.',4,'1'),
('Plus 500','11/17/1995','0','05/27/2009','Poland','Torgnon','P.O. Box 668, 8811 Leo. Rd.',2,'0'),
('Interactive Brokers (IBKR)','11/20/2014','0','07/17/2000','Palau','Maltignano','332-5345 Imperdiet, Ave',3,'0'),
('Goldman Sachs Group Inc','07/08/1998','0','11/30/2005','Venezuela','Outremont','9304 Tellus Rd.',1,'0'),
('JPMorgan Chase & Co','01/16/2012','0','01/10/2015','American Samoa','Guilmi','7948 Mi Road',2,'0'),
('Bank of America Corp','04/13/2017','1','10/04/2021','Turkey','Hamm','Ap #931-2119 Suspendisse St.',1,'0');
GO


INSERT INTO AccountHolders([NationalID],[BrokerID],[FirstName],[LastName],[Adress],[Phone],[Email],[TotalAssets],[Nationality])
VALUES(263653163,5,'Hilda','Hunter','18-208','070 8752 2705','vel@arcuVestibulum.co.uk','$64244.70','Israel'),
(236565337,7,'Rae','Pacheco','129841','(0110) 556 7812','volutpat@hendreritconsectetuercursus.net','$02425.57','USA'),
(213540640,5,'Martina','Rowland','357384','0845 46 46','a@dui.com','$79850.74','Korea, North'),
(219265824,8,'Amity','Howe','60402','07711 782768','molestie.arcu@nonloremvitae.org','$76410.11','Bhutan'),
(235727240,8,'Morgan','Rosario','29-352','(0101) 337 4075','lacus.Quisque@est.net','$26375.19','Pakistan'),
(230522780,8,'Aphrodite','Battle','5337 WB','(0141) 521 5035','commodo@nec.edu','$95233.24','Syria'),
(251028686,9,'Ruth','Day','JM5R 8MI','0327 438 1384','eros@nonlobortisquis.org','$81490.87','Germany'),
(225376233,1,'Montana','Mann','556275','07624 455790','ac.turpis@sagittislobortismauris.co.uk','$04350.57','Hungary'),
(248528196,10,'Kessie','Burke','6276 TN','(016977) 4058','nisl@odioauctorvitae.com','$15534.22','Serbia'),
(230274153,5,'Linda','Ward','Z6746','(01053) 46127','magnis.dis@veliteget.ca','$01612.53','Jordan');
GO


INSERT INTO Stocks([Name],[TypeOfAsset],[MarketPrice],[ExpenseRatio],[DividenedDistribution],[inIndex],[MarketSizeCap],[Sector],[NumberOfStocks])
VALUES(' DBCS Ltd','Stock','$100000.0',0,'M','1','L','Data Tech',1625),
('Binance','Stock','$114.29',0,'Q','0','S','Finance',2950),
('Tesla','Stock','$103.63',0,'Y','1','L','AeroSpace',50000),
('Nasdaq 100 ETF','ETF','$56.64',0.015,'Y','1','L','Retail',4558),
('Appel','Stock','$190.36',0,'Q','0','L','Computer hardware',2000000),
('ARK FINTECH INNOVATION ETF','ETF','$37.60',0.075,'Q','1','B','Financial technology',3039),
('Salesforce.com','Stock','$165.19',0,null,'1','M','Artificial intelligence',4043),
('Amazon AWS','Stock','$127.22',0,'Q','0','L','Cloud technology',2452),
('Paolo Alto','Stock','$267.79',0,'M','0','S','Cyber security',6713),
('Facebook corp','Stock','$140.33',0, null,'0','L','Artificial intelligence',100000);
GO


INSERT INTO Orders([StockISIN],[BuyOrSell],[OrderType],[TimeOfSubbmition],[IsActive],[OrderStatus],[InvestorId],[Price],[Quantity]) 
VALUES(7,'Buy','Limit','2021-04-22 09:15:43','N','Done',7,155,284),---1
(7,'Sell','Limit','2021-04-22 09:47:04','N','Done',10,155,284), ---1
(6,'Buy','Limit','2021-04-22 10:26:04','N','Done',4,260,356),---2
(5,'Buy','Limit','2021-04-22 10:42:07','N','Done',10,140,30), ---3
(10,'Buy','Market','2021-04-22 10:58:24','N','Done',5,203,288), ---4
(2,'Buy','Market','2021-04-22 11:23:04','Y','Pending',10,180,326), ---X
(1,'Buy','Limit','2021-04-22 11:41:45','N','Pending',5,282,46),----X
(4,'Buy','Limit','2021-04-22 11:47:04','N','Done',6,80,423),---5
(8,'Buy','Limit','2021-04-22 12:33:12','N','Done',7,42,241),----6
(8,'Sell','Limit','2021-04-22 12:15:37','N','Done',3,42,241), ----6
(6,'Buy','Limit','2021-04-22 12:36:06','Y','Pending',7,91,30),-------------7
(5,'Sell','Limit','2021-04-22 12:54:33','N','Partly Done',6,140,35),----3
(1,'Sell','Limit','2021-04-22 12:51:19','N','Cancelled',4,14,274),  ----X
(4,'Sell','Limit','2021-04-22 13:00:53','N','Done',1,80,423), --- 5
(5,'Sell','Limit','2021-04-22 13:44:15','Y','Pending',3,88,332),  -----X
(5,'Sell','Market','2021-04-22 13:49:58','Y','Done',1,150,456),-----------------8
(6,'Sell','Limit','2021-04-22 14:09:08','N','Done',5,260,356),---2
(5,'Sell','Limit','2021-04-22 14:31:36','N','Cancelled',5,243,79), ----- X
(6,'Sell','Limit','2021-04-22 14:34:21','N','Done',2,91,30),   ------------7
(2,'Sell','Market','2021-04-22 14:41:09','Y','Pending',10,147,322), ------X
(6,'Sell','Limit','2021-04-22 15:02:07','N','Done',3,141,437),---------------------9
(5,'Buy','Limit','2021-04-22 15:21:20','Y','Pending',6,150,456),-----------------8
(4,'Buy','Limit','2021-04-22 15:39:06','N','Done',5,244,451),
(10,'Sell','Market','2021-04-22 15:40:19','N','Done',4,180,288), --- 4
(3,'Buy','Limit','2021-04-22 15:53:20','Y','Done',8,234,410),--------------------------------10
(6,'Buy','Market','2021-04-22 16:00:05','N','Done',8,141,437),
(10,'Sell','Limit','2021-04-22 16:13:41','N','Done',3,234,410),
(3,'Buy','Limit','2021-04-22 16:16:28','N','Cancelled',8,296,312), 
(4,'Sell','Limit','2021-04-22 16:26:28','N','Pending',3,224,299),
(5,'Sell','Limit','2021-04-22 16:27:45','N','Updated',4,44,79);
GO


INSERT INTO Transactions([FirstOrderID],[SecondOrderID],[Quantity],[Price],[TimeOfTransaction],[TranStatus],[IsSecured], [SecurityCode]) 
VALUES(1,2,155.00,284,'2021-04-22 09:47:04','Done','Y', 6931771020),
(3,17,260,356,'2021-04-22 14:09:08','Done','Y',2097241434 ),
(15,11,140,30,'2021-04-22 14:10:56','Done','Y',1513889492 ), ----3
(23,7,288,203,'2021-04-22 15:40:19','Done','Y', 9676255122),--4
(9,6,423,80,'2021-04-22 13:00:53','Done','Y', 1313868816), ---5
(11,23,42,241,'2021-04-22 12:54:33','Done','Y',3714123761 ), --6
(13,29,30,91,'2021-04-22 14:34:21','Done','Y', 7953114569),
(5,3,456,150,'2021-04-22 15:21:20','Done','Y', 3115259451), --8
(30,5,437,437,'2021-04-22 15:02:07','Done','Y', 2785987274), --9
(17,21,410,234,'2021-04-22 15:53:20','Done','N', 4948181774); ---10

select * from Transactions