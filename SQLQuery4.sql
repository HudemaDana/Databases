create database Bank
go

use Bank
go

create table Customers(
	id int primary key identity(1, 1),
	name varchar(100) default 'anonim',
	birthDate datetime 
);

create table BankAccounts(
	id int primary key identity(1, 1),
	customerId int foreign key references Customers(id),

	IBAN varchar(20),
	currentBalance int default '0',
	holder int
)

create table Cards(
	id int primary key identity(1, 1),
	bankAccountId int foreign key references BankAccounts(id),

	cardNumber varchar(20),
	CVV varchar(3)
)

create table Transactions(
	id int primary key identity(1, 1),
	cardId int foreign key references Cards(id),
	sumMoney int default '0'
)

create table ATMs(
	id int primary key identity(1, 1),
	addressATM varchar(1000) default 'atlantis idk some kind of neant',
)

create table Withdraws(
	id int primary key identity(1, 1),
	ATMid int foreign key references ATMs(id),
	Tid int foreign key references Transactions(id),
	transactionStartTime datetime
)

create or alter procedure DeleteTransaction @cardid int as
begin 
	declare @nr int;
	set @nr = (select count(*) from Transactions where cardId = @cardid);

	if (@nr <> 0)
		begin
			delete
			from Transactions 
			where cardId = @cardid
		end
	else
		begin
			print('no row to be deleted');
		end
end
go

create or alter view vwGetCardNumberForAllATMs as
	select c.cardNumber as 'Card Number' 
	from Cards c	inner join Transactions t on c.id = t.cardId
					inner join Withdraws w on t.id = w.Tid
	group by c.cardNumber
	having count(*) = (select count(*) from ATMs)
go

create or alter function GetCardsWithTSum() returns table as
return 
	select c.cardNumber, c.CVV
	from Cards c inner join Transactions t on c.id = t.cardId
	group by c.cardNumber,c.CVV
	having SUM(t.sumMoney) > 2000
go