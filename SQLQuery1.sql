DROP DATABASE IF EXISTS UniversityDB
GO

CREATE DATABASE UniversityDB;
GO

USE UniversityDB;

CREATE TABLE Module -- store course details
(
    mCode CHAR(4) PRIMARY KEY,
    mName VARCHAR(50),
    year INT,
    semester INT
)

CREATE TABLE Student --store student details
(
    sId CHAR(4) PRIMARY KEY,
    sName VARCHAR(50),
    age INT,
    gpa REAL
)
CREATE TABLE Follow --store the student and courses they follow
(
    mCode CHAR(4) REFERENCES Module(mCode),
    sId CHAR(4) REFERENCES Student(sId),
    registeredDate DATE,
    PRIMARY KEY(mCode,sid)
)
CREATE TABLE Hall -- store the lecture hall details
(
    hId CHAR(4) PRIMARY KEY,
    buildingNo INT,
    floorNo INT,
    capacity INT
)

CREATE TABLE HallAllocation -- store the hall allocation for modules
(
    mCode CHAR(4) REFERENCES Module(mCode),
    hId CHAR(4) REFERENCES Hall(hId),
    day CHAR(3),-- ex: Mon, Tue, Wed
    startTime TIME,
    endTime TIME,
    PRIMARY KEY(mCode,hId)
)

-- sample data
INSERT INTO Module VALUES('M001','Database Management 01',1,2)
INSERT INTO Module VALUES('M002','Object Oriented Programming',2,1)
INSERT INTO Module VALUES('M003','Database Management 02',2,1)
INSERT INTO Module VALUES('M004','Database Management 03',2,1)


INSERT INTO Student VALUES('S001','Saman Perera',21,3.5)
INSERT INTO Student VALUES('S002','Kamal Fernando',22,3.2)
INSERT INTO Student VALUES('S003','Aruni Jayathilake',20,2.9)
INSERT INTO Student VALUES('S004','Kamal Jayasinghe',25,3.1)


INSERT INTO Hall VALUES('H001',2,3,200)
INSERT INTO Hall VALUES('H002',1,2,300)
INSERT INTO Hall VALUES('H003',3,4,250)
INSERT INTO Hall VALUES('H004',3,4,3)

INSERT INTO Follow VALUES('M001','S001','16-Sep-2020')
INSERT INTO Follow VALUES('M001','S002','12-Sep-2020')
INSERT INTO Follow VALUES('M002','S001','11-Aug-2020')
INSERT INTO Follow VALUES('M002','S002','23-Aug-2020')
INSERT INTO Follow VALUES('M002','S003','02-Sep-2020')

INSERT INTO HallAllocation VALUES('M001','H001','Tue','08:15','10:15')
INSERT INTO HallAllocation VALUES('M002','H001','Wed','10:30','12:30')
INSERT INTO HallAllocation VALUES('M003','H002','Wed','10:30','12:30')

go

--01
create view ModuleDetails
as
select m.mName,count(f.mCode) as mCount,m.year
from Module m 
FULL OUTER JOIN  Follow f
on m.mCode=f.mCode
group by m.mName,m.year
go

--02
create function getStudentsPerModule(@mname as VARCHAR(50))
returns int
 as 
 BEGIN 
 return
 (
	select count(f.mCode) as mCount
	from Follow f
	where f.mCode=
	(
	select m.mCode
	from Module m
	where m.mName= @mname
	)
) 
 END 

  select dbo.getStudentsPerModule('Object Oriented Programming')

  go

  --3
  create trigger checkHallCapacity
  on HallAllocation
  AFTER INSERT
  as
  begin
    if 
	(
	 (
	 select capacity
	 from Hall h
	 where h.hId=
	  (
	   select hId
	   from INSERTED
	  )
	 )
	   	>=
	 (
	  select COUNT(h.mCode)
	  from HallAllocation h
	  where h.hId=
	  (
	   select hId
	   from INSERTED
	  )
	 
	 )
	)
	PRINT 'capacity of hall is adequate';
	else
	PRINT 'capacity of hall is not  adequate';
  end

  go

INSERT INTO HallAllocation VALUES('M001','H004','Tue','08:15','10:15')
INSERT INTO HallAllocation VALUES('M002','H004','Wed','10:30','12:30')
INSERT INTO HallAllocation VALUES('M003','H004','Wed','10:30','12:30')
INSERT INTO HallAllocation VALUES('M004','H004','Tue','08:15','10:15')
