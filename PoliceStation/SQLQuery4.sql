use PoliceStation
go

--a. modify the type of a column;

CREATE OR ALTER PROCEDURE do1 AS
BEGIN
	ALTER table Investigations
	ALTER COLUMN investigation_date varchar(11)
END
GO


CREATE OR ALTER PROCEDURE undo1 AS
BEGIN
	ALTER table Investigations
	ALTER COLUMN investigation_date date
END
GO

--------------------------------------------------
--b. add / remove a column;
CREATE OR ALTER PROCEDURE do2 AS
BEGIN
	ALTER table PoliceStation
	ADD employees_nr int
END
GO

CREATE OR ALTER PROCEDURE undo2 AS
BEGIN
	ALTER table PoliceStation
	DROP COLUMN employees_nr
END
GO

--------------------------------------------------
--c. add / remove a DEFAULT constraint;

CREATE OR ALTER PROCEDURE do3 AS
BEGIN
	ALTER table Cops
	ADD CONSTRAINT df_salary DEFAULT 2000 FOR Salary 
END
GO


CREATE OR ALTER PROCEDURE undo3 AS
BEGIN
	ALTER table Cops
	DROP CONSTRAINT df_salary 
END
GO

--------------------------------------------------
--d. add / remove a primary key;
CREATE OR ALTER PROCEDURE do4 AS
BEGIN
	ALTER table Usage
	Drop constraint pk_Usage 
END
GO
--exec do4

CREATE OR ALTER PROCEDURE undo4 AS
BEGIN
	ALTER table Usage
	ADD constraint pk_Usage Primary Key(Tid,PCid)
END
GO
--exec undo4

--------------------------------------------------
--e. add / remove a candidate key;
CREATE OR ALTER PROCEDURE do5 AS
BEGIN
	ALTER table CallCenterPeople
	ADD constraint ck_CallCenterPeople UNIQUE (CNP) 
END
GO
--exec do5

CREATE OR ALTER PROCEDURE undo5 AS
BEGIN
	ALTER table CallCenterPeople
	DROP constraint ck_CallCenterPeople 
END
GO
--exec undo5
--------------------------------------------------
--f. add / remove a foreign key;
CREATE OR ALTER PROCEDURE do6 AS
BEGIN
	ALTER table Calls
	ADD constraint fk_Calls foreign key(Iid) references Investigations(Iid)
END
GO
--exec do6

CREATE OR ALTER PROCEDURE undo6 AS
BEGIN
	ALTER table Calls
	DROP constraint fk_Calls
END
GO
--exec undo6
--------------------------------------------------
--g. create / drop a table
CREATE OR ALTER PROCEDURE do7 AS
BEGIN
	CREATE TABLE Doggies(
	DogId int primary key identity,
	Tid int foreign key references Teams(Tid), 
	DogName varchar(50),
	DogBreed varchar(50) default 'chiuaua')
END
GO
--exec do7

CREATE OR ALTER PROCEDURE undo7 AS
BEGIN
	drop table Doggies
END
GO
--exec undo7
--------------------------------------------------

DROP TABLE IF EXISTS DatabaseVersion
CREATE TABLE DatabaseVersion
	(
		crt_version INT
	);
GO

--insert into DatabaseVersion values(0);
--------------------------------------------------

CREATE OR ALTER PROCEDURE goToVersion(@version int) AS
BEGIN

	DECLARE @crtVersion int 
	set @crtVersion = (SELECT crt_version 
							FROM DatabaseVersion)
	DECLARE @procedure varchar(100)

	IF(@version<0 or @version>7)
		BEGIN
			PRINT 'Invalid input'
			RETURN
		END
	ELSE
		BEGIN
			IF(@version > @crtVersion)
			BEGIN
				WHILE(@version > @crtVersion)
				BEGIN
					SET @crtVersion = @crtVersion + 1
					SET @procedure = 'do'+ cast(@crtVersion as varchar(5))
					EXEC @procedure
					--Print 'procedure '+@crtVersion+' was executed' 
				END
			END
			ELSE
			BEGIN
				WHILE(@version < @crtVersion)
				BEGIN
					IF (@crtVersion!=0) 
					BEGIN
						SET @procedure='undo'+CAST(@crtVersion AS VARCHAR(5))
						EXEC @procedure
						--Print 'procedure '+@crtVersion+' was executed' 
					END
					SET @crtVersion=@crtVersion-1
				END	
			END

			UPDATE DatabaseVersion SET crt_version = @version
			RETURN
		END
END
GO

exec goToVersion 0
select * from DatabaseVersion 




