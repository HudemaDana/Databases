create database PoliceStation
go

use PoliceStation
go

create table PoliceStation(
	PSid int primary key IDENTITY,
	address varchar(150) NOT NULL,
	city varchar(50) NOT NULL,
	country varchar(50) NOT NULL,
	phone_number varchar(13) NOT NULL
)

create table Office(
	Oid int primary key IDENTITY,
	PSid int foreign key references PoliceStation(PSid) not null
)

create table Teams(
	Tid int primary key IDENTITY,
	Oid int foreign key references Office(Oid) not null,
	name varchar(50)
)

create table Equipments(
	Eid int primary key IDENTITY,
	equipment_name varchar(100) NOT NULL 
)


create table Cops(
	CNP varchar(13) primary key,
	Tid int foreign key references Teams(Tid) not null,
	Eid int foreign key references Equipments(Eid) not null,
	fname varchar(50) NOT NULL, 
	lname varchar(50) NOT NULL,
	address varchar(150) NOT NULL,
	phone_number varchar(13) NOT NULL,
)

create table PoliceCars(
	PCid int primary key IDENTITY,
	PSid int foreign key references PoliceStation(PSid) not null,
	car_number varchar(10) NOT NULL,
	model varchar(100)
)

create table Usage(
	Tid int foreign key references Teams(Tid) not null,
	PCid int foreign key references PoliceCars(PCid) not null,

	constraint PK_Usage primary key(Tid,PCid)
)

create table Investigations(
	Iid int primary key IDENTITY,
	Tid int foreign key references Teams(Tid) not null,
	investigation_date date not null,
	descr varchar(1000) NOT NULL
)

create table People(
	Pid int primary key IDENTITY,
	CNP varchar(13) not null,
	fname varchar(50) NOT NULL,
	lname varchar(50) NOT NULL,
	address varchar(150),
	phone_number varchar(13) NOT NULL,
	email varchar(100)
)

create table Roles(
	Rid int primary key IDENTITY,
	role_name varchar(50) NOT NULL
)

create table PeopleInInvestigation(
	Pid int foreign key references People(Pid) not null,
	Iid int foreign key references Investigations(Iid) not null,
	Rid int foreign key references Roles(Rid) not null,

	constraint PK_PeopleInInvestigation primary key(Pid,Iid,Rid)
)

create table CallCenterPeople(
	CCPid int primary key IDENTITY,
    CNP varchar(13) not null,
	fname varchar(50) NOT NULL,
	lname varchar(50) NOT NULL,
	PSid int foreign key references PoliceStation(PSid) not null
)

create table Calls(
	CallId int primary key Identity,
	CCPid int foreign key references CallCenterPeople(CCPid) not null,
	descr varchar(8000) default 'Incognito call'
)