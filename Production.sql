create database Production
go

use Production 
go

create table ComponentTypes(
	CTid int primary key identity(1,1),
	name varchar(100),
	description varchar(100) default 'no description'
	);

create table Components(
	Cid int primary key identity(1,1),
	name varchar(100),

	CTid int foreign key references ComponentTypes(CTid)
	);

create table Companies(
	Compid int primary key identity(1,1),
	name varchar(100) unique,
	address varchar(100)
	);

create table Models(
	Mid int primary key identity(1,1),
	name varchar(100) unique,

	Compid int foreign key references Companies(Compid)
);

create table ComponentModels(
		CMid int primary key identity(1,1),

		Mid int foreign key references Models(Mid),
		Cid int foreign key references Components(Cid),

		price float default 0.0,
		ass_time int default 0
);


--insert into ComponentTypes values('c1','d1');
--insert into ComponentTypes values('c2','d2');

--insert into Components values('component1',1);
--insert into Components values('component2',2);

--insert into Companies values('name1','addr1');
--insert into Companies values('name2','addr2');

--insert into Models values('Mname1',1);
--insert into Models values('Mname2',2);

--insert into ComponentModels values(1,1,12,35);
--insert into ComponentModels values(1,2,50,19);
--insert into ComponentModels values(2,2,50,19);



create or alter procedure addComponent(@model int, @component int, @price float, @time int) as
begin
	declare @nr int;
	set @nr = 0;

	select @nr = count(*) from ComponentModels where Mid = @model and Cid = @component

	if(@nr <> 0)
	begin
		update ComponentModels
		set price = @price, ass_time = @time
		where Mid = @model and Cid = @component
	end
	else
	begin
		insert into ComponentModels(Mid,Cid,price,ass_time) values (@model, @component, @price, @time)
	end
end
go

create or alter view showCompanies as
	select c.name, count(*) as NrComponents
	from Companies c	left join Models m on c.Compid = m.Mid
						inner join ComponentModels cm on cm.Mid = m.Mid
	group by c.name
	having count(*) = (select count(*) from Components)
go
select * from showCompanies


create or alter function listCompAvg(@R time) returns table as
return 
begin
	select c.name
	from Components c inner join ComponentModels cm on c.Cid = cm.Cid
	group by c.name
	having avg(cm.ass_time)>(CONVERT(INT, REPLACE(
                       CONVERT(varchar(8), @R, 108),
                       ':',
                       ''
                    )
              ))
end
go