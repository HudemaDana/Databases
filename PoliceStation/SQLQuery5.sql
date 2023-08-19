use PoliceStation
go

--alter table Usage
--add usageMinutes int default 0;

--insert into Tables(Name) values('PoliceStation'),('PoliceCars'),('Usage');
--insert into Tests(Name) values('selectView'),('addPoliceStation'),('deletePoliceStation'),('addPoliceCars'),('deletePoliceCars'),('addUsage'),('deleteUsage');
--insert into Views(Name) values('viewPoliceStation'),('viewPoliceCars'),('viewUsage');
--go

--insert into TestViews(TestID,ViewID) values(1,1),(1,2),(1,3)
--go

select * from Tests
select * from Tables
select * from TestTables

select * from PoliceStation
select * from PoliceCars
select * from Usage
go

--insert into TestTables(TestID,TableID, NoOfRows, Position) values (7,3,100,1),(5,2,100,2),(3,1,100,3),(2,1,10,1),(4,2,100,2),(6,3,999,3);
--go

--update TestTables set NoOfRows = '800' where TestID = 6

create or alter view viewPoliceStation
as
	Select * 
	From PoliceStation
go

create or alter view viewPoliceCars
as
	Select PoliceCars.PSid
	From PoliceCars INNER JOIN PoliceStation on PoliceCars.PSid = PoliceStation.PSid
go

create or alter view viewUsage
as
	Select PoliceCars.car_number, count(Usage.Tid) as nrTeams
	From Usage left JOIN PoliceCars on PoliceCars.PCid = Usage.PCid 
	group by PoliceCars.car_number
go

--exec viewPoliceStation
--exec viewPoliceCars
--exec viewUsage

create or alter procedure selectView
(@name varchar(100))
as
begin
	declare @sql varchar(250) = 'select * from ' + @name
	exec(@sql)
end 
go

create or alter procedure addPoliceStation
@n int
as
begin
	declare @i int=0
	while @i<@n
	begin
		insert into PoliceStation(address,city,country,phone_number) values (CONCAT('PoliceStationAddress', @i),'c','c','c')
		set @i=@i+1
	end
end
go

create or alter procedure deletePoliceStation
as
begin
---in loc de pcId pun coloana in care am pus datele random
	delete from PoliceStation where address like 'PoliceStationAddress%'
end
go

create or alter procedure addPoliceCars
@n int
as
begin
	declare @i int=0
	while @i<@n
	begin
		insert into PoliceCars(car_number,PSid,model) values (CONCAT('CarNr', @i),1,'a')
		set @i=@i+1
	end
end
go

create or alter procedure deletePoliceCars
as
begin
	delete from PoliceCars where car_number like 'CarNr%'
end
go


create or alter procedure addUsage
@n int
as
begin
	declare @PCid int
	declare @Tid int
	declare addUsageCurs CURSOR
		for

		---PoliceStation pc -> fac select pentru el ca sa le ia doar pe cele de test
		-- select PCid from PoliceCars where typeNume like 'Type %'

			select t.Tid, pc.PCid
			from Teams t cross join (select PCid from PoliceCars where car_number like 'CarNr%') pc  
	
	open addUsageCurs
	fetch addUsageCurs
	into @Tid, @PCid
	
	declare @i int = 0
	while @i<@n
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

create or alter procedure deleteUsage
as
begin
	delete from Usage where usageMinutes<=0
end
go

create or alter procedure runDeleteTests
as
begin
	declare @testId int

	declare fetchDeleteTests cursor
	for select tt.TestID from TestTables tt inner join Tests t on  tt.TestID=t.TestID where Name like 'delete%' order by Position asc

	open fetchDeleteTests
	fetch fetchDeleteTests into @testId
	while @@FETCH_STATUS = 0
	begin
		declare @cmd varchar(MAX) = (select Name from Tests where TestID = @testId)
		print(concat('deleting data from ',@cmd))
		exec @cmd
		
		fetch fetchDeleteTests into @testId
	end
	close fetchDeleteTests
	deallocate fetchDeleteTests
end
go


create or alter procedure runInsertTests
(@runTestId int)
as
begin
	declare @testId int
	declare @tableId int
	declare @numOfRows int

	declare fetchInsertTests cursor
	for select tt.TestID,tt.TableID, tt.NoOfRows from TestTables tt inner join Tests t on  tt.TestID=t.TestID where Name like 'add%' order by Position asc

	open fetchInsertTests
	fetch fetchInsertTests into @testId, @tableId, @numOfRows
	while @@FETCH_STATUS = 0
	begin
		declare @cmd varchar(MAX) = (select Name from Tests where TestID = @testId)
		declare @startTime datetime = GETDATE()
		
		print(concat('inserting data in ',@cmd))
		exec (@cmd + ' ' + @numOfRows)

		declare @endTime datetime = GETDATE()
		insert into TestRunTables(TestRunID, TableID, StartAt, EndAt) values (@runTestId, @tableId, @startTime, @endTime)

		fetch fetchInsertTests into @testId, @tableId, @numOfRows
	end

	close fetchInsertTests
	deallocate fetchInsertTests
end
go

create or alter procedure runViewTests
(@runTestId int)
as
begin
	declare @testId int
	declare @viewId int

	declare fetchViewTests cursor for
	select * from TestViews

	open fetchViewTests
	fetch fetchViewTests into @testId, @viewId
	while @@FETCH_STATUS = 0
	begin
		declare @cmd varchar(MAX) = (select Name from Tests where TestID = @testId)
		declare @args varchar(MAX) = (select Name from Views where ViewID = @viewId)
		declare @startTime datetime = GETDATE()
		
		print(concat('view data from ',@cmd))
		exec (@cmd + ' ' + @args)

		declare @endTime datetime = GETDATE()
		insert into TestRunViews(TestRunID, ViewID, StartAt, EndAt) values (@runTestId, @viewId, @startTime, @endTime)

		fetch fetchViewTests into @testId, @viewId
	end

	close fetchViewTests
	deallocate fetchViewTests
end
go

create or alter procedure main
as 
begin 
	insert into TestRuns(startAt) values(getdate())
	declare @testId int = SCOPE_IDENTITY()
	exec runDeleteTests
	exec runInsertTests @testId
	exec runViewTests @testId

	update TestRuns set Description = 'delete + insert + view', EndAt = GETDATE() where TestRunID = @testId

	select * from TestRunTables
	select * from TestRunViews
	select * from TestRuns

end
go

create or alter procedure runTests
(@n int)
as
begin
	declare @i int = 0
	while @i < @n
	begin
		exec main
		set @i = @i + 1
	end

	--select * from TestRunTables
	--select * from TestRunViews
	--select * from TestRuns
end
go

exec runTests 1
select * from Usage

