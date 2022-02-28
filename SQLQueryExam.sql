CREATE DATABASE exam;
GO

USE exam;

CREATE TABLE Doctor
(
    did CHAR(4) PRIMARY KEY,
    dname VARCHAR(50),
	DOB DATE,
	speciality VARCHAR(20)

)

CREATE TABLE Ward
(
    wid CHAR(4) PRIMARY KEY,
    wardName VARCHAR(50),
    did CHAR(4) REFERENCES Doctor(did),
	maxPatients INT
)

CREATE TABLE Patient
(
    pid CHAR(4) PRIMARY KEY,
    pname VARCHAR(50),
	DOB DATE,
    mobileNo CHAR(10)
 
)

CREATE TABLE Admitted
(

	pid CHAR(4) REFERENCES Patient(pid),
    wid CHAR(4) REFERENCES Ward(wid),
	bedNo INT,
    dateAdmitted DATE,
	dateDischarged DATE,
	PRIMARY KEY(wid, pid)
)

GO

INSERT INTO Doctor VALUES('D001','Dishen Fernando','1991-02-23','Gynaecologist')
INSERT INTO Doctor VALUES('D002','Subodha hansini','1992-08-28','Cardiologist')
INSERT INTO Doctor VALUES('D003','Sithum Dilshan','1989-03-17','Neuro Surgeon')

INSERT INTO Ward VALUES('W001','Cardiology','D002',16)
INSERT INTO Ward VALUES('W002','Neurology','D003',15)
INSERT INTO Ward VALUES('W003','Accident & Emergency','D002',10)
INSERT INTO Ward VALUES('W004','Gynecology','D001',20)

INSERT INTO Patient VALUES('P001','Chamal De Silva','1999-04-12','0779887556')
INSERT INTO Patient VALUES('P002','Ayomi Perara','1996-05-12','0717687333')
INSERT INTO Patient VALUES('P003','Sisil Kotugoda','1986-06-12','0789877655')
INSERT INTO Patient VALUES('P004','Minoli Akarsha','1990-12-12','0726554112')
INSERT INTO Patient VALUES('P005','Vithum Jayakodi','2000-09-12','0773226557')

INSERT INTO Admitted VALUES('P001','W002',3,'2020-01-12','2020-01-20')
INSERT INTO Admitted VALUES('P002','W003',9,'2021-10-18',NULL)
INSERT INTO Admitted VALUES('P003','W001',12,'2021-06-09','2020-06-29')
INSERT INTO Admitted VALUES('P004','W003',8,'2021-10-20',NULL)
INSERT INTO Admitted VALUES('P005','W002',4,'2021-09-04','2021-09-15')

GO

SELECT *
FROM Doctor
SELECT *
FROM Ward
SELECT *
FROM Patient
SELECT *
FROM Admitted
GO

--02
CREATE VIEW PatientsAdmitted
AS
SELECT P.pid, p.pname, p.DOB , w.wardName
FROM  Ward w ,Admitted a,Patient p
WHERE a.dateDischarged IS NULL AND a.wid=w.wid AND a.pid=p.pid

GO


--03
CREATE FUNCTION PatientsOfWard(@wid CHAR(4))
RETURNS INT
 as 
 BEGIN 
RETURN
 (
   SELECT COUNT(wid)
   FROM Admitted
   WHERE wid=@wid AND dateDischarged IS NULL
 ) 
 END 

select dbo.PatientsOfWard('W003')
GO

--04
CREATE PROCEDURE hospitalizationOfPatient
@pid VARCHAR(4),
@pName VARCHAR(50),
@DOB DATE,
@mobileNumber CHAR(10),
@wID VARCHAR(4),
@bedNo INT,
@admissionDate DATE
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM Patient WHERE pid=@pID)
	BEGIN
		INSERT INTO Patient VALUES(@pID,@pName,@DOB,@mobileNumber)
	END
	IF EXISTS(SELECT * FROM Ward WHERE wid=@wID)
	BEGIN
		INSERT INTO Admitted VALUES(@pID,@wID,@bedNo,@admissionDate)
	END
	ELSE
	BEGIN
		PRINT 'Unknown wardID in the ward table.'
	END
END

GO

 --05
 CREATE TRIGGER MaxPatientChecking
 ON Ward
  AFTER INSERT
  AS
  BEGIN
  DECLARE @wid CHAR(4)
  SELECT @wid=wid
  FROM INSERTED
  IF 
	(
	 (
	 SELECT maxPatients
	 FROM Ward
	 WHERE wid=@wid
	 
	 )
	   	>=
	 (
	  SELECT COUNT(wid)
      FROM Admitted
      WHERE wid=@wid AND dateDischarged IS NULL
	 )
	)
	PRINT 'ward does not exceed its maximum capacity for patients';
  END
go