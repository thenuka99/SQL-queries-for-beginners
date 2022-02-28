
--Q 01
create database [194055L]
use [194055L]

--Q 02
create table Client
(
 ClientNo varchar(6),
 Name varchar(20),
 City  varchar(20),
 Date_joined datetime,
 Balance_Due money,
 primary key (ClientNo)
)

create table Product
(
 ProductNo varchar(6),
 Description varchar(50),
 Profit_Margin int,
 Qty_available int,
 Re_Order_Level int,
 Item_Cost money,
 Selling_Price money,
 primary key (ProductNo)
)

--Q 03
insert into Client values('C001','Sagara','Colombo','2010-12-20',25000)
insert into Client values('C002','Nisansala','Galle','2014-08-05',12000)
insert into Client values('C003','Pamith','Piliyandala','2008-01-30',4500)
insert into Client values('C004','Amali','Moratuwa','2015-06-15',20000)
insert into Client values('C005','Nayana','Nugegoda','2011-12-18',16500)
insert into Client values('C006','Krishan','Anuradhapura','2014-03-04',22000)
insert into Client values('C007','Ruwanthi','Maharagama','2015-05-04',8500)

select * from Client

insert into Product values('P0001','FlashDrive 8 GB',5,100,30,1000,1050)
insert into Product values('P0002','Keyboard',10,25,5,3500,3850)
insert into Product values('P0003','Mouse',10,50,15,1200,1320)
insert into Product values('P0004','HardDisk 400 GB',15,20,5,10000,11500)
insert into Product values('P0005','HardDisk 1 TB',15,35,3,15000,17250)
insert into Product values('P0006','FlashDrive 32 GB',5,100,25,1100,1155)
insert into Product values('P0007','LED Monitor 15”',15,15,5,18000,20700)
insert into Product values('P0008','LED Monitor 17”',15,10,2,30000,34500)

select * from Product

--Q 04

--Q 04.1
select Name from Client

--Q 04.2
select distinct City from Client

--Q 04.3
select ClientNo from Client where City= 'Colombo'

--Q 04.4
select Name from Client where Name like 'N%'

--Q 04.5
select Name from Client where Date_joined<'2014-01-01'

--Q 04.6
select Name,City from Client where year(Date_joined)<'2014'

--Q 04.7
select Name from Client where Balance_Due>10000.00

--Q 04.8
select AVG(Profit_Margin) from Product

--Q 04.9
select Description from Product where Profit_Margin>10

--Q 04.10
select Qty_Available*Item_Cost from Product where Description='Keyboard'