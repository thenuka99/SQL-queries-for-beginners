-- 194055L herath H.M.J.T
-- IN2400 – Database Management Systems

--02)
/*create database FantasyMovies;

use FantasyMovies;
--01)
create table Casts
(
 actorid int,
 movieid int,
 actorRole varchar(15),
 constraint Casts_pk primary key(actorid,movieid),
 constraint Casts_fk1 FOREIGN key(actorid) REFERENCES Actor(actorid),
 constraint Casts_fk2 FOREIGN key(movieid) REFERENCES Movie(movieid),
)
create table Rating
(
 movieid int,
 reviewerId int,
 reviewerName varchar(20),
 reviewStars int CHECK (reviewStars BETWEEN 1 and 10),
 constraint Rating_pk primary key (movieid,reviewerId),
 constraint Rating_fk foreign key (movieid) REFERENCES Movie(movieid)
)
create table Actor
(
 actorid int primary key,
 actorName varchar(20)
)
create table Movie
(
 movieid int,
 movieTitle varchar(20),
 movieYear date,
 movieRank real default 0,
 constraint Movie_pk primary key(movieid)
)*/


--03)
create procedure CountOfActors 
@title varchar(20),
@count int out
AS
BEGIN
select @count=count(m.movieid) 
from Movie m,Casts c 
where m.movieid=c.movieid and m.movieTitle=@title
END

go

--04)
create TRIGGER UpdateMovieRate
ON Rating
AFTER  INSERT
AS
BEGIN
DECLARE @mId int
DECLARE @count int
DECLARE @total int
DECLARE @tot real
DECLARE @totcount real
DECLARE @avg real

select @mId=movieid from inserted
select @count=count(r.movieid),@total=sum(r.reviewStars) 
from Rating r 
where r.movieid=@mId

set @totcount=cast(@count as real)
set @tot=cast(@total as real)
set @avg=@tot/@totcount

update Movie set movieRank=@avg where movieid=@mId

END