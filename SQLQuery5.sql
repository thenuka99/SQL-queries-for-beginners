DROP DATABASE IF EXISTS onlineStore
GO

CREATE DATABASE onlineStore;
GO

USE onlineStore;

CREATE TABLE Products -- store product details
(
    pid CHAR(4) PRIMARY KEY,
    pName varchar(15), -- product name
    unitPrice REAL,
    unitsInStock INT
)

CREATE TABLE Suppliers -- store supplier details
(
    sid CHAR(4) PRIMARY KEY,
    sName VARCHAR(50), -- supplier name
    sAddress VARCHAR(20) -- supplier address
)

CREATE TABLE Supplies -- store the products supplied by the supplier
(
    sid CHAR(4) REFERENCES Suppliers(sid),
    pid CHAR(4) REFERENCES Products(pid),
    suppliedDate DATE,
    qty INT, -- quantity supplied
    purchasePrice REAL -- purchase price of a unit (Note: total purchase price = qty * purchasePrice)
    PRIMARY KEY(sid, pid, suppliedDate)
)

CREATE TABLE SupplierPayments -- store the supplier payments for products supplies on a particular date
(
    sid CHAR(4) REFERENCES Suppliers(sid),
    LastsuppliedDate DATE,
    totAmountToPay REAL,
    PRIMARY KEY(sid)
)-- Note: This table will be updated by the trigger in part 3

--sample data
INSERT INTO Products VALUES('P001','Key Board',400,50)
INSERT INTO Products VALUES('P002','Mouse',300,70)
INSERT INTO Products VALUES('P003','Hard Disk 1TB',11000,40)

INSERT INTO Suppliers VALUES('S001','K.N. Enterprises','Katubedda')
INSERT INTO Suppliers VALUES('S002','Silva Stores','Maharagama')
INSERT INTO Suppliers VALUES('S003','MT Traders','Moratuwa')

INSERT INTO Supplies VALUES('S001','P001','16-Sep-2020',50,200)
INSERT INTO Supplies VALUES('S001','P002','16-Sep-2020',40,100)
INSERT INTO Supplies VALUES('S001','P001','15-Sep-2020',30,200)
INSERT INTO Supplies VALUES('S002','P001','15-Sep-2020',100,250)
INSERT INTO Supplies VALUES('S002','P002','15-Sep-2020',50,240)
INSERT INTO Supplies VALUES('S002','P003','15-Sep-2020',30,9000)



--01
Create view DailyTotalItemsReceive
as
select s.suppliedDate,SUM(s.qty) as total_quantity,p.pName
from Supplies s
FULL OUTER JOIN  Products p
on s.pid=p.pid
group by s.suppliedDate,p.pName

go

--02
Create function CalcPayment(@sid CHAR(4),@suppliedDate DATE)
returns int
 as 
 BEGIN 
 return
 (
	select sum(s.purchasePrice) as total_payment 
	from Supplies s
	where s.sid=@sid AND s.suppliedDate=@suppliedDate
) 
 END 

 select dbo.CalcPayment('S002','15-Sep-2020')
 go

 --03
 CREATE TRIGGER updateSupplyInfo
 ON Supplies
  AFTER INSERT
  AS
  BEGIN
  DECLARE @sid CHAR(4)
  DECLARE @suppliedDate DATE
  DECLARE @purchasePrice REAL
  SELECT @sid=sid,@suppliedDate=suppliedDate,@purchasePrice=purchasePrice
  FROM INSERTED
   if 
   not Exists(
	  SELECT *
	  FROM SupplierPayments s
	  WHERE s.sid=@sid	  
   )
    BEGIN
	  INSERT INTO SupplierPayments VALUES(@sid,@suppliedDate,@purchasePrice)
	 END
	ELSE
	 BEGIN
	   UPDATE SupplierPayments
       SET LastsuppliedDate=@suppliedDate,totAmountToPay=totAmountToPay+@purchasePrice
       WHERE sid=@sid
	 END
  END
go
 
SELECT*
FROM SupplierPayments






DROP TABLE Supplies
DROP TABLE SupplierPayments