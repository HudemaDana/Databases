--create database ShoesShop
--go

use ShoesShop
go

--drop table BoughtShoes
--drop table Stock
--drop table Shoes
--drop table Women
--drop table ShoesModels
--drop table PresShoes
--go

--create table PresShops(
--	PSid int primary key identity,
--	name varchar(100) not null,
--	city varchar(100) not null
--);

--create table ShoesModels(
--	SMid int primary key identity,
--	name varchar(100) default '',
--	season varchar(100) not null,

--);

--create table Women(
--	Wid int primary key identity,
--	name varchar(100) not null,
--	mAmount float default 0.0
--);

--create table Shoes(
--	Sid int primary key identity,
--	price float not null,
	
--	SMid int foreign key references ShoesModels(SMid)
--	);


--create table Stock(
--	STid int primary key identity,
	
--	Sid int foreign key references Shoes(Sid),
--	PSid int foreign key references PresShops(PSid),
	
--	nrAvailable int default 0
--	);

--create table BoughtShoes(
--	BSid int primary key identity,

--	Wid int foreign key references Women(Wid),
--	PSid int foreign key references PresShops(PSid),

--	nrShoes int default 0,
--	spentAmount float default 0.0	
--);

----------------------------------------------------

create or alter procedure addShoe(@shoe int, @pres int, @nrShoes int) as
begin
	declare @nr int;
	set @nr = 0;
	select @nr = count(*) From Stock S Where S.Sid = @shoe and S.PSid = @pres

	if(@nr<> 0) 
		begin
			update Stock
			set nrAvailable = nrAvailable + @nrShoes
			where Sid = @shoe and PSid = @pres
		end
	else
		begin
			insert into Stock(Sid,PSid,nrAvailable) values (@shoe,@pres,@nrShoes)
		end
end
go



create or alter view showWomen as
begin
	select w.name
	from Women w	left join BoughtShoes bs on w.Wid = bs.Wid
					inner join Stock s on s.PSid = bs.PSid
					inner join Shoes sh on sh.Sid = s.Sid
	where sh.SMid = @model
	group by w.id,w.name
	having count(distinct w.id)> 2				
end
go

create or alter function takeModel(@model int) returns table as
return
	select SMid from ShoeModels where SMid = @model
go