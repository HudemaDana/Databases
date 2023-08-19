create database MonitoringSystem
go

use MonitoringSystem
go

create table RoomTypes(
	id int primary key identity(1,1),
	name varchar(100) unique,
	descr varchar(100) default 'nothing'
)
create table Rooms(
	id int primary key identity(1,1),
	name varchar(100),

	typeId int foreign key references RoomTypes(id)
)
create table Departments(
	id int primary key identity(1,1),
	name varchar(100),
	descr varchar(100) default 'nothing',
	budget int
)
create table Employees(
	id int primary key identity(1,1),
	fname varchar(100),
	lname varchar(100),
	birthDate datetime,
	salary int
)
create table SharedDepartEmployee(
	id int primary key identity(1,1),
	
	DId int foreign key references Departments(id),
	EId int foreign key references Employees(id),
)
create table Badges(
	id int primary key identity(1,1),

	descr varchar(100) default 'nothing',
	EId int foreign key references Employees(id)
)
create table Logs(
	id int primary key identity(1,1),

	logDateTime datetime,
	logValue varchar(100) check (logValue in ('enter','exit')),
	BId int foreign key references Badges(id),
	EId int foreign key references Employees(id),
	RId int foreign key references Rooms(id)
)

insert into RoomTypes values('conference','n1'),('relaxation','n2'),('office','n3');
insert into Rooms values('r1',1),('r2',1),('r3',2),('r4',3);
insert into Departments values('d1','departament1',130),('d2','departament2',205),('d3','departament1',100)
insert into Employees(fname,lname,salary) values('George','Mihai',2000),('Ion','Ionel',3500),('Anca','Ancescu',4500);
insert into SharedDepartEmployee values(1,1),(1,2),(1,3),(2,1),(3,2)
insert into Badges values('ceva1',1),('ceva2',1),('ceva3',2),('ceva4',3);
insert into Logs(logValue,BId,EId,RId) values('enter',1,1,1),('exit',1,1,1),('enter',1,2,2),('enter',2,3,1)

create or alter procedure DeleteBadgeFromLog(@bid int) as
begin
	declare @nr int
	set @nr = 0
	select @nr = count(*) from Logs where Bid = @bid

	if(@nr <> 0)
	begin
		delete from Logs where Bid = @bid
	end
	else
	begin
		print('nothing to delete')
	end
end
go

select * from Logs
exec DeleteBadgeFromLog @bid = 1

create or alter view vwGetMaxEmployee as
	select e.fname, e.lname,count(*) as 'CountEmployee'
	from Employees e inner join Logs l on e.id = l.EId
	group by e.fname, e.lname
	having count(*) = (select max(l.num) from (SELECT COUNT(*) AS num
												FROM Logs group by Eid) l)
go
select * from vwGetMaxEmployee

create or alter function GetNames(@N int) returns table return
	select d.name
	from Departments d inner join SharedDepartEmployee s on d.id = s.DId
	group by d.name
	having count(s.EId) > @N
go

