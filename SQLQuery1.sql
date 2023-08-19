use Restaurant
go

--create table Restaurants(
--	Rid int primary key identity,
--	name varchar(100) unique,
--);

--create table ProductTypes(
--	PTid int primary key identity,
--	name varchar(100),
--	description varchar(100)
--);

--create table Products(
--	Pid int primary key identity,
--	name varchar(100),
--	description varchar(100),
--	PTid int foreign key references ProductTypes(PTid),

--);

--create table Menus(
--	Mid int primary key identity,
--	name varchar(100) unique,

--	Rid int foreign key references Restaurants(Rid)

--);

--create table MenuItems(
--	MIid int primary key identity,

--	Mid int foreign key references Menus(Mid),
--	Pid int foreign key references Products(Pid),
--	weight int not null,
--	price float not null,
--);

--------------------------------------------------------------

create or alter procedure addProduct(@menu int, @product int,@weight int, @price float) AS
	declare @nr int;
	set @nr = 0;
	select @nr = count(*) From MenuItems Where Mid = @menu and Pid = @product
	
	
	if (@nr<>0)
		begin
			update MenuItems 
			set weight = @weight, price = @price
			where Mid = @menu and Pid = @product
		end
	else
		begin
			insert into MenuItems(Mid,Pid,weight,price) values(@menu,@product,@weight, @price);
		end
	
go


create or alter view showRestaurants as
	select R.name
	from Restaurants R	left join Menus M on R.Rid = M.Rid
						inner join MenuItems IM on M.Mid = IM.Mid
	group by R.name
	having count(distinct IM.MIid) = (	select count(*) 
										from Products )
go

create or alter function productNameAvg(@R float) returns table as
return
	select P.name
	from Products P left join MenuItems MI on P.Pid = MI.MIid
	group by P.Pid, P.name
	having AVG(MI.weight/MI.price)>@R
go