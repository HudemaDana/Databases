--Create a database to manage a chocolate shop. The database will store data about the presents that contain chocolate.
--a) The entities of interest to the problem domain are: Chocolate Type, Chocolate, Present and Child.
--b) Each chocolate has a name, a weight, a price and belongs to a type. A chocolate type has besides the name, also a description.
--c) Each present has a title, a description, a price, and a list of chocolates with the quantity and the expiration date included.
--d) A child has name, surname, age, gender, and a list of chocolates with the recommended quantity to be eaten.
--1) Write an SQL script that creates the corresponding relational data model.
--2) Implement a stored procedure that receives a chocolate, a present, a quantity, an expiration date, and adds the chocolate to the present. If the chocolate is already included in the present, the quantity and the expiration date are updated.
--3) Create a view that shows the names of the chocolates included in all the presents.
--4) Implement a function that lists the names of the children that haven't received any chocolate.

create database CShop
go 

use CShop
go

create table ChocolateTypes(
	CTid int primary key identity(1,1),
	
	name varchar(100),
	descr varchar(100)
	);

create table Chocolate(
	Cid int primary key identity(1,1),
	name varchar(100),
	weight int,
	price float,
	
	CTid int foreign key references ChocolateTypes(CTid)
	);

create table Present(
	Pid int primary key identity(1,1),
	
	title varchar(100),
	descr varchar(100),
	price float,
	);

create table PresentChocolate(
	PCid int primary key identity,
	
	Cid int foreign key references Chocolate(Cid),
	Pid int foreign key references Present(Pid),

	quality int,
	expiration date
	);

create table Child(
	CHid int primary key identity(1,1),
	name varchar(100),
	surname varchar(100),
	age int,
	gender varchar(100),
	);

create table ChildChocolate(
	CCid int primary key identity,
	
	Cid int foreign key references Chocolate(Cid),
	CHid int foreign key references Child(CHid),

	quality int
);

insert into ChocolateTypes values('belgiana', 'buna');
insert into ChocolateTypes values('neagra', 'da');

insert into Chocolate values('a' , 10, 100, 1);
insert into Chocolate values('b', 5, 13, 2);

insert into Present values('t1','da',15);
insert into Present values('t2','nu', 20);

insert into PresentChocolate values(1,1,9,'2014-9-28');
insert into PresentChocolate values(1,2,7,'2019-5-12');

insert into Child values('n1','s1',13,'F');
insert into Child values('n2','s2',19,'M');
insert into Child values('n3','s2',19,'M');

insert into ChildChocolate values(1,1,6);
insert into ChildChocolate values(1,2,5);


--2
create or alter procedure addChoco(@choco int, @present int,@quality int, @exp_date date) as
begin
	declare @nr int;
	set @nr = 0;
	select @nr = count(*) from PresentChocolate where Cid = @choco and Pid = @present

	if(@nr <> 0)
		begin
			update PresentChocolate
			set quality = @quality, expiration = @exp_date
			where Cid = @choco and Pid = @present
		end
	else
		begin
			insert into PresentChocolate(Cid,Pid,quality,expiration) values (@choco, @present, @quality, @exp_date);
		end
end
go

exec addChoco @choco=1, @present=2, @quality=3,@exp_date = '2000-2-2'

--3
create or alter view showChoco as
	select c.name
	from Chocolate c left join PresentChocolate pc on c.Cid = pc.Cid 
	group by c.Cid,c.name
	having count(distinct c.Cid) = (select count(*) from Present)
go

select *
from showChoco

create or alter function listChildren() returns table as
return
	select ch.name
	from Child ch 
	where ch.CHid not in (select cc.CCid
							from ChildChocolate cc)
go

select * from listChildren()