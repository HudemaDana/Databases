use PoliceStation
go

-----------------------------------------------------------------------

--ALTER TABLE Usage
--DROP CONSTRAINT PK_Usage;

--ALTER TABLE Usage
--ADD CONSTRAINT unique_Usage UNIQUE (Tid, PCid)

--alter table Usage
--add Uid int identity

--ALTER TABLE Usage
--ADD PRIMARY KEY (Uid);

--ALTER TABLE PoliceCars
--ADD UNIQUE (car_number);

--alter table PoliceCars
--add serial_number int unique

--alter table PoliceCars
--drop column serial_number

--delete from PoliceCars

--DBCC CHECKIDENT ('PoliceCars', RESEED, 0);


---------------------------------------------------------------------
---------------------------------------------------------------------

--PoliceCars(							- Ta
--	PCid			(not null)			- aid
--	PSid			(not null)
--	car_number				
--	model
--	serial_number	(unique)			- a2
--)
---------------------------------------------------------------------

--Teams(					- Tb
--	Tid		(not null)		- bid
--	Oid		(not null)		- b2
--	name
--)
---------------------------------------------------------------------

--Usage(							- Tc
--	Uid			(not null)			- cid 
--	PCid		(not null)			- aid 
--	Tid			(not null)			- bid
--	usage_date
--	usageMinutes
--)
---------------------------------------------------------------------
---------------------------------------------------------------------


create or alter procedure InsertPoliceCars @seed int
as
begin
	declare @i int=0
	while @i<@seed
	begin
		insert into PoliceCars(car_number,PSid,serial_number) values (CONCAT('CarNr', @i),(floor(rand()*(7-2+1)+2)),@i+10)
		set @i=@i+1
	end
end
go

create or alter procedure InsertTeams @seed int
as
begin
	declare @i int = 0
	while @i<@seed
	begin
		insert into Teams(Oid, name) values ((floor(rand()*(7-2+1)+2)), concat('TeamName',@i))
		set @i = @i+1
	end
end
go

create or alter procedure InsertUsage @seed int
as
begin
	declare @PCid int
	declare @Tid int
	declare addUsageCurs CURSOR
		for
			select t.Tid, pc.PCid
			from (select Tid from Teams where name like 'TeamName%') t cross join (select PCid from PoliceCars where car_number like 'CarNr%') pc  
	
	open addUsageCurs
	fetch addUsageCurs
	into @Tid, @PCid
	
	declare @i int = 0
	while @i<@seed
		begin
		insert into Usage(Tid, PCid, usageMinutes) values (@Tid, @PCid, -1*@i)
		set @i=@i+1

		fetch addUsageCurs
		into @Tid, @PCid
		end
	close addUsageCurs
	deallocate addUsageCurs 
end
go


---------------------------------------------------------------------
---------------------------------------------------------------------

exec InsertPoliceCars 100000  
exec InsertTeams 10000
exec InsertUsage 10000000

---------------------------------------------------------------------
---------------------------------------------------------------------



--a
--clustered index scan
SELECT *
FROM  PoliceCars 
WHERE serial_number%2 = 0  
ORDER BY PCid DESC


--clustered index seek
SELECT * 
FROM PoliceCars 
WHERE PCid > 5000


--nonclustered index scan
DROP INDEX IF EXISTS nonClusteredIndexPoliceCars on PoliceCars
CREATE NONCLUSTERED INDEX nonClusteredIndexPoliceCars on PoliceCars(serial_number)


SELECT serial_number
FROM PoliceCars 
ORDER BY serial_number


--nonclustered index seek
SELECT PCid 
FROM PoliceCars 
WHERE serial_number > 200 and serial_number < 1000


--key lookup
SELECT car_number 
FROM PoliceCars 
WHERE serial_number = 350

---------------------------------------------------------------------
---------------------------------------------------------------------
--b
DROP INDEX IF EXISTS Idx_NC_Oid ON Teams

--without creating said index, the execution plan is a clustered index scan
--Select estimated subtree cost: 0.0439193

SELECT *
FROM Teams 
WHERE Oid = 2


CREATE NONCLUSTERED INDEX Idx_NC_Oid ON Teams(Oid) INCLUDE(name)

--now, the execution plan will show a nonclustered index seek, which would be more efficient
--Select estimated subtree cost: 0.0091031

SELECT *
FROM Teams 
WHERE Oid = 2


---------------------------------------------------------------------
---------------------------------------------------------------------
--c
--this will use the previously created index and split the cost...

create or alter view someView as 
	SELECT top 1000 p.PCid as PoliceCarId, t.name as TeamName
	FROM PoliceCars p
		INNER JOIN Usage u ON p.PCid = u.PCid
		INNER JOIN Teams t ON u.Tid = t.Tid
	order by t.Tid
go

DROP INDEX IF EXISTS Idx_NC_Oid ON Teams
DROP INDEX IF EXISTS nonClusteredIndexPoliceCars on PoliceCars

SELECT * FROM someView -- estimated cost: 30.95

DROP INDEX IF EXISTS nonClusteredIndexPoliceCars2 ON PoliceCars
DROP INDEX IF EXISTS nonClusteredIndexUsage ON Usage
DROP INDEX IF EXISTS nonClusteredIndexTeams ON Teams

CREATE NONCLUSTERED INDEX nonClusteredIndexPoliceCars2 on PoliceCars(serial_number)
CREATE NONCLUSTERED INDEX nonClusteredIndexUsage on Usage(Uid) include (PCid,Tid)
CREATE NONCLUSTERED INDEX nonClusteredIndexTeams on Teams(Oid) include (name)




