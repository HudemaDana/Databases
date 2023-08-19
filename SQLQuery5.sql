create database Train
go

use Train 
go

create table TrainTypes(
	id int primary key identity(1,1),
	
	name varchar(100) default 'CFR',
	description varchar(100) default 'lautari be ready'
)

create table Trains(
	id int primary key identity(1,1),
	typeId int foreign key references TrainTypes(id),
	
	name varchar(100) default 'IR1831'
)

create table Routes(
	id int primary key identity(1,1),
	trainId int foreign key references Trains(id),
	
	name varchar(100) unique
)

create table Stations(
	id int primary key identity(1,1),
	
	name varchar(100) unique
)

create table Stops(
	id int primary key identity(1,1),

	Rid int foreign key references Routes(id),
	Sid int foreign key references Stations(id),

	ArrivalTime time,
	DepartureTime time
)

create or alter procedure AddStationToRoute(@route int, @station int,@at time, @dt time) as
begin
	declare @nr int
	set @nr = 0
	select @nr = count(*) from Stops where Rid = @route and Sid = @station

	if(@nr = 0)
	begin
		insert into Stops(Rid,Sid,ArrivalTime,DepartureTime) values (@route,@station,@at,@dt)
	end
	else
	begin
		update Stops
		set ArrivalTime = @at, DepartureTime = @dt
		where Rid = @route and Sid = @station
	end
end
go

create or alter view vwGetRoutesNames as
	select distinct r.name as 'Route Name'
	from Routes r	inner join Stops s on r.id = s.Rid
					--inner join Stations st on s.Sid = st.id
	group by r.name
	having count(distinct r.name) = (select count(*) from Stations)
go

create or alter function GetStationNames(@R int) returns table as
return
	select distinct st.name as 'Station Name'
	from Stations st left join Stops s on st.id = s.Sid
	group by st.name
	having count(s.Rid) >= @R
go
