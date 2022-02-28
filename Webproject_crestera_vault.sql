

--create database
create database crestera;

--use database
use crestera;

go

--create Tables
--user Table
create table _user(
userId varchar(6) primary key,
firstName varchar(20),
lastName varchar(20),
email varchar(30),
_password varchar(15),
bio varchar(50),
IsAdmin varchar(5) default 'false'
--we can't store image (image save as string so we can only save dummy string so we will pass it)
--UserImage varchar(200)
);

--user Circle Table
create table userCircle(
circleId varchar(6) primary key,
circleName varchar(20),
NoOfMember int,
userId varchar(6) REFERENCES _user(userId)
);

--member of circle Table
create table circleMemberList(
circleId varchar(6) REFERENCES userCircle(circleId),
userId varchar(6) REFERENCES _user(userId),
PRIMARY KEY(circleId , userId)
);

--////////////////////////////////////////////////////////////vault\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--Folder Table
create table folder(
folderId varchar(6) primary key,
folderName varchar(20),
userId varchar(6) REFERENCES _user(userId),
);

--File Table
create table _file(
_fileId varchar(6) primary key,
_fileName varchar(20),
userId varchar(6) REFERENCES _user(userId),
);

--parent folder  of file table
create table parentFile(
folderId  varchar(6) REFERENCES folder(folderId ),
_fileId varchar(6) REFERENCES _file(_fileId),
PRIMARY KEY(folderId , _fileId)
);

--parent folder  of folder table
create table parentFolder(
parentFolderId  varchar(6) REFERENCES folder(folderId ),
childFolderId  varchar(6) REFERENCES folder(folderId ),
PRIMARY KEY(parentFolderId, childFolderId)
);

--folder (shared with) user table
create table folderSharedWith(
folderId  varchar(6) REFERENCES folder(folderId ),
userId varchar(6) REFERENCES _user(userId),
_expireDate date,
permissionLevel varchar(10),
PRIMARY KEY(folderId , userId)
);

-- file (shared with) user table
create table fileSharedWith(
_fileId varchar(6) REFERENCES _file(_fileId),
userId varchar(6) REFERENCES _user(userId),
_expireDate date,
permissionLevel varchar(10),
PRIMARY KEY(userId , _fileId)
);

--folder (shared with) userCircle table
create table folderSharedWithCircle(
folderId  varchar(6) REFERENCES folder(folderId),
circleId varchar(6) REFERENCES userCircle(circleId),
_expireDate date,
permissionLevel varchar(10),
PRIMARY KEY(folderId , circleId)
);

-- file (shared with) userCircle table
create table fileSharedWithCircle(
_fileId varchar(6) REFERENCES _file(_fileId),
circleId varchar(6) REFERENCES userCircle(circleId),
_expireDate date,
permissionLevel varchar(10),
PRIMARY KEY(circleId, _fileId)
);
--////////////////////////////////////////////////////////////note\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--note Table
create table note(
noteId varchar(6) primary key,
noteTitle varchar(20),
documentText varchar(100),
userId varchar(6) REFERENCES _user(userId),
);

--encryptedArea Table
create table encryptedArea(
encryptedAreaId varchar(6) primary key,
documentText varchar(100),
noteId varchar(6) REFERENCES note(noteId),
);

-- note (shared with) user table
create table noteSharedWith(
noteId varchar(6) REFERENCES note(noteId),
userId varchar(6) REFERENCES _user(userId),
permissionLevel varchar(10),
PRIMARY KEY(noteId , userId)
);

--note (shared with) userCircle table
create table noteSharedWithCircle(
noteId  varchar(6) REFERENCES note(noteId),
circleId varchar(6) REFERENCES userCircle(circleId),
permissionLevel varchar(10),
PRIMARY KEY(noteId , circleId)
);

--////////////////////////////////////////////////////////////board\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--board Table
create table board(
boardId varchar(6) primary key,
boardTitle varchar(20),
userId varchar(6) REFERENCES _user(userId),
);

--textBox Table
create table textBox(
textBoxId varchar(6) primary key,
documentText varchar(100),
boardId varchar(6) REFERENCES board(boardId),
);


--shapeTable
create table shape(
shapeId varchar(6) primary key,
shapeType varchar(30),
stroke int,
colour char(7),
boardId varchar(6) REFERENCES board(boardId),
);

--coordinate Table
create table coordinate(
coordinateId varchar(6) primary key,
xCoordinate int,
yCoordinate int,
shapeId varchar(6) REFERENCES shape(shapeId),
);

-- board (shared with) user table
create table boardSharedWith(
boardId varchar(6) REFERENCES board(boardId),
userId varchar(6) REFERENCES _user(userId),
permissionLevel varchar(10),
PRIMARY KEY(boardId , userId)
);

--board (shared with) userCircle table
create table boardSharedWithCircle(
boardId  varchar(6) REFERENCES board(boardId),
circleId varchar(6) REFERENCES userCircle(circleId),
permissionLevel varchar(10),
PRIMARY KEY(boardId , circleId)
);
go
--////////////////////////////////////////////////////////////quary\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

--user Signup 
CREATE PROCEDURE signup
@userId varchar(6),
@firstName varchar(20),
@lastName varchar(20),
@email varchar(30),
@_password varchar(15)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM _user WHERE email=@email)
	 BEGIN
		INSERT INTO _user VALUES(@userId,@firstName,@lastName,@email,@_password,NULL,'false')
	 END
	ELSE
	 BEGIN
		PRINT 'user already exist.'
	 END
END
--execute create procedure & add users
EXEC signup 'u00001','user1','user1','user1@gmail.com','user123'
EXEC signup 'u00002','user2','user2','user2@gmail.com','user123'
EXEC signup 'u00003','user3','user3','user3@gmail.com','user123'
EXEC signup 'u00004','user4','user4','user4@gmail.com','user123'
EXEC signup 'u00005','user5','user5','user5@gmail.com','user123'
EXEC signup 'u00006','user6','user6','user6@gmail.com','user123'
EXEC signup 'u00007','user7','user7','user7@gmail.com','user123'
--check it work
SELECT *
FROM _user
GO

--user SignIn
CREATE PROCEDURE signin
@email varchar(30),
@_password varchar(15)
AS
BEGIN
    IF  EXISTS(SELECT * FROM _user WHERE email=@email)
	 BEGIN
		IF (@_password = (SELECT @_password FROM _user WHERE email=@email))
		  BEGIN
		   PRINT 'loggin successfully.'
		  END
        ELSE  
		  BEGIN
		   PRINT 'invalid password.'
	      END
	 END
	ELSE
	 BEGIN
		PRINT 'invalid email.'
	 END
END
--execute create procedure & check
EXEC signin 'user1@gmail.com','user123'
EXEC signin 'user@gmail.com','user123'
EXEC signin 'user1@gmail.com','user223'

GO

--Delete user
CREATE PROCEDURE deleteUser
@userId varchar(6)
AS
BEGIN
    IF  EXISTS(SELECT * FROM _user WHERE userId=@userId)
	 BEGIN
		DELETE FROM _user
        WHERE userId = @userId
	 END
	ELSE
	 BEGIN
		PRINT 'user not exist.'
	 END
END
--execute create procedure & add users
EXEC deleteUser 'u00001'
--check it work
select *
from _user
GO

--create circle
CREATE PROCEDURE circle
@circleId varchar(6),
@circleName varchar(20),
@NoOfMember int,
@userId varchar(6)
AS
BEGIN
INSERT INTO userCircle VALUES(@circleId,@circleName,@NoOfMember,@userId)
EXEC addUserToCircle @circleId,@userId
END
--execute create procedure & add users
EXEC circle 'c00001','circle1',0,'u00001'
EXEC circle 'c00002','circle2',0,'u00001'
EXEC circle 'c00003','circle3',0,'u00002'
EXEC circle 'c00004','circle4',0,'u00003'
--check it work
SELECT *
FROM userCircle
GO

--add user to circle
CREATE PROCEDURE addUserToCircle
@circleId varchar(6),
@userId varchar(6)
AS
BEGIN
	 BEGIN
		IF EXISTS(SELECT * FROM circleMemberList WHERE userId=@userId AND circleId=@circleId)
		  BEGIN
		   PRINT 'Already added.'
		  END
        ELSE  
		  BEGIN
		   INSERT INTO circleMemberList VALUES(@circleId,@userId)
		   UPDATE userCircle SET NoOfMember=dbo.usersOfCircle(@circleId)
	       WHERE circleId=@circleId
	      END
	 END
END
--execute create procedure & check
EXEC addUserToCircle 'c00001','u00002'
EXEC addUserToCircle 'c00003','u00002'
EXEC addUserToCircle 'c00001','u00002'
EXEC addUserToCircle 'c00001','u00004'
EXEC addUserToCircle 'c00001','u00005'
EXEC addUserToCircle 'c00001','u00006'
EXEC addUserToCircle 'c00001','u00007'
--check it work
SELECT *
FROM circleMemberList
GO

--user count in  circle
CREATE FUNCTION usersOfCircle(@circleId VARCHAR(6))
RETURNS INT
 AS
 BEGIN 
RETURN
 (
   SELECT COUNT(circleId)
   FROM circleMemberList
   WHERE circleId=@circleId 
 ) 
 END 
GO

--user max checker in  circle
  CREATE TRIGGER MaxuserChecking
  ON userCircle 
  AFTER INSERT
  AS
  BEGIN
  DECLARE @circleId VARCHAR(6)
  SELECT @circleId=circleId
  FROM INSERTED
  IF ( 5 < dbo.usersOfCircle(@circleId))
	    BEGIN
		   PRINT 'ward does not exceed its maximum capacity for patients'
		END
  END
GO


--////////////////////////////////////////////////////////////vault\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--////////////////////////////////////////////////////////////note\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--user create Note
CREATE PROCEDURE createNote
@noteId varchar(6),
@noteTitle varchar(20),
@documentText varchar(100),
@userId varchar(6)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM note WHERE noteTitle=@noteTitle and userId=@userId)
	 BEGIN
		INSERT INTO note VALUES(@noteId,@noteTitle,@documentText,@userId)
	 END
	ELSE
	 BEGIN
		PRINT 'note already exist.'
	 END
END
--execute create procedure & create notes
EXEC createNote 'n00001','Note1','<p><strong>Test1</strong></p>','u00001'
EXEC createNote 'n00002','Note2','<p><strong>Test2</strong></p>','u00002'
EXEC createNote 'n00003','Note3','<p><strong>Test3</strong></p>','u00003'
EXEC createNote 'n00004','Note4','<p><strong>Test4</strong></p>','u00004'
EXEC createNote 'n00005','Note5','<p><strong>Test5</strong></p>','u00005'
EXEC createNote 'n00006','Note6','<p><strong>Test6</strong></p>','u00006'
EXEC createNote 'n00007','Note7','<p><strong>Test7</strong></p>','u00007'
--check it work
SELECT *
FROM note
GO
--////////////////////////////////////////////////////////////board\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


--CREATE Folder 
CREATE PROCEDURE createFolder
@folderId varchar(6),
@folderName varchar(20),
@userId varchar(6)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM folder WHERE folderName=@folderName and userId=@userId)
	 BEGIN
		INSERT INTO folder VALUES(@folderId,@folderName,@userId)
	 END
	ELSE
	 BEGIN
		PRINT 'folder already exist.'
	 END
END
--execute create procedure & create folders
EXEC createFolder 'fd0001','Note1','u00001'
EXEC createFolder 'fd0002','Note2','u00002'
EXEC createFolder 'fd0003','Note3','u00003'
EXEC createFolder 'fd0004','Note4','u00004'
EXEC createFolder 'fd0005','Note5','u00005'
EXEC createFolder 'fd0006','Note6','u00006'
EXEC createFolder 'fd0007','Note7','u00007'
--check it work
SELECT *
FROM note
GO

--CREATE FILE
CREATE PROCEDURE createFile
@_fileId varchar(6),
@_fileName varchar(20),
@userId varchar(6)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM _file WHERE _fileName=@_fileName and userId=@userId)
	 BEGIN
		INSERT INTO note VALUES(@_fileId,@_fileName,@userId)
	 END
	ELSE
	 BEGIN
		PRINT 'File already exist.'
	 END
END
--execute create procedure & create files
EXEC createFile 'f00001','File1','u00001'
EXEC createFile 'f00002','File2','u00002'
EXEC createFile 'f00003','File3','u00003'
EXEC createFile 'f00004','File4','u00004'
EXEC createFile 'f00005','File5','u00005'
EXEC createFile 'f00006','File6','u00006'
EXEC createFile 'f00007','File7','u00007'
--check it work
SELECT *
FROM note
GO

--update Folder Name
CREATE PROCEDURE  updateFolderName @folderId VARCHAR(6),@newName VARCHAR(20)
 AS
 BEGIN
     UPDATE folder SET folderName=@newName 
	 WHERE folderId=@folderId
  END

--execute create procedure updateFolderName
EXEC updateFolderName 'f0001','renamefolder'

--check it work
SELECT *
FROM folder

GO

--update File Name
CREATE PROCEDURE updateFileName @fileId VARCHAR(6),@newName VARCHAR(20)
 AS
 BEGIN
     update _file set _fileName=@newName 
	 where _fileId=@fileId
END
--execute create procedure updateFileName
EXEC updateFileName 'fd0001',renameFile
--check it work
SELECT *
FROM _file

go