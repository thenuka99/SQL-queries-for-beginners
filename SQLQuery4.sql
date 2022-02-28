use master
drop database if exists DBStore
go
CREATE database DBStore
go
use DBstore;
go
create table Customers
(
    cid char(4) primary key,
    name VARCHAR(50),
    phone char(10),
    country VARCHAR(20)
)

create table Employees
(
    eid char(4) primary key,
    ename varchar(50),
    phone char(10),
    birthdate date
)

create table Products
(
    productId char(4) primary key,
    productName varchar(15),
    unitPrice real,
    unitInStock int,
    ROL int
)

create table Orders
(
    oid int primary key,
    eid char(4) references Employees(eid),
    cid char(4) references Customers(cid),
    orderDate date,
    requiredDate date,
    shippedDate date,
    cost real
)

create table orderDetails
(
    oid int,
    productId char(4) references Products(productId),
    quantity int,
    discount real,
    constraint orderDetails_pk PRIMARY KEY(oid,productId)
)

insert into Customers values('C001','Saman','0772446552','Sri Lanka')
insert into Customers values('C002','John','0987665446','USA')
insert into Customers values('C003','Mashato','0927665334','Japan')

insert into Employees values('E001','Kasun Weerasekara','0702994459','07-Apr-1997')
insert into Employees values('E002','Sathira Wijerathna','0760510056','05-Feb-1996')

insert into Products values('P001','Hard Disk',12000,80,50)
insert into Products values('P002','Flash Drive',3200,60,20)
insert into Products values('P003','LCD Monitor',24000,35,15)


INSERT into Orders VALUES(1,'E001','C001','01-Sep-2020','09-Sep-2020','02-Sep-2020',null)

INSERT into orderDetails VALUES(1,'P001',3,0.1);
INSERT into orderDetails VALUES(1,'P002',5,0.15);
INSERT into orderDetails VALUES(1,'P003',2,0.15);

create function orderInfo(@ordid int )
 returns @myTable TABLE 
  (
	productName varchar(15),
	qty int,
	unitAmt real,
	totAmt real,
	discount real,
	payAmt real
 )
 as 
 BEGIN 
	Insert into @myTable 
	select p.productName, od.quantity, p.unitPrice, (od.quantity*p.unitPrice),(od.quantity*p.unitPrice*od.discount) ,( (od.quantity*p.unitPrice) -(od.quantity*p.unitPrice*od.discount))
	from Products p, orderDetails od
	where p.productId = od.productId 
	return 
 END 
  select *  from orderInfo(1)