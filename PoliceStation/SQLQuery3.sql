use PoliceStation
go

--A.TAKE ALL PEOPLE WHO WORK IN POLICE STATIONS and their first name contains a or b
----------------------------------------

SELECT *
FROM(SELECT fname AS PeopleInSection
	FROM Cops
	UNION
	SELECT fname
	FROM CallCenterPeople) t
WHERE t.PeopleInSection LIKE '%a%' OR t.PeopleInSection LIKE '%b%' 


--TAKE ALL DESCRIPTIONS OF ALL CASES IN POLICE STATIONS
----------------------------------------------------------

SELECT descr
FROM Investigations

UNION ALL

SELECT descr
FROM Calls

--B.ALL Officers and Detectives THAT HAVE BEEN INVOLVED INTO AN ACCIDENT
---------------------------------------------------------------------------
SELECT fname,lname
FROM Cops
WHERE cop_rank in ('Officer','Detective')

INTERSECT

SELECT fname,lname
FROM People

--TAKE ALL DATES IN WHICH A POLICE CAR HAVE BEEN USED FOR AN INVESTIGATION FOR A CERTAIN TEAM
----------------------------------------------------------------------------------------------------
SELECT investigation_date as CarUsed
FROM Investigations
WHERE (Tid in (2,5,7)) and (investigation_date in (
	SELECT usage_date 
	FROM Usage));


--C.all usage of police cars in investigations that doesn't include blackmail or lost things
-------------------------------------------------------
SELECT usage_date
From Usage

Except

Select investigation_date
From Investigations
Where descr not in ('%blackmail%','%lost%');


--Take all equipments that are not currently used by cops
---------------------------------------------------------
Select equipment_name
from Equipments
where Eid not in (
	Select Eid
	From Cops);


--D.all police stations that have office that are in used by teams that have at the moment cops in it
---------------------------------------------------------
Select distinct p.PSid as 'Id',p.country as 'Country',p.city as 'City'
From PoliceStation p
inner join Office o
on p.PSid = o.PSid
inner join Teams t
on o.Oid = t.Oid
inner join Cops c
on  t.Tid =c.Tid;

--
----------------------------------------------------------
Select o.Oid as 'OfficeId',o.PSid as 'PoliceStationId',o.name as 'OfficeName'
from Office o
right join Teams t
on o.Oid = t.Tid
right join Cops c
on  t.Oid =c.Tid;

--
--------------------------------------------------------------
Select ps.PSid, ps.address,cc.CCPid,c.descr as 'CallDescription'
from PoliceStation ps
left join CallCenterPeople cc
on ps.PSid = cc.PSid
left join Calls c
on cc.CCPid = c.CCPid

--
--------------------------------------------------------------
Select t.name
From Teams t
full join Cops c
on t.Tid = c.Tid
full join Equipments e
on c.Eid = e.Eid
full join Usage u
on t.Tid = u.Tid
full join PoliceCars p
on u.PCid = p.PCid

--E.all investigation that didn't have a police car in usage from a team with a given office
----------------------------------------------------------------
SELECT  i.Iid as 'Id',i.descr as 'InvestigationDescr'
FROM Investigations i
WHERE investigation_date not in (
	SELECT usage_date 
	FROM Usage u
	WHERE u.Tid in(
		Select t.Tid
		From Teams t, Office o
		Where t.Oid = o.Oid and o.name not in ('P2','I1','I3')));

--All equipments that are currently used by cops
-----------------------------------------
Select equipment_name
from Equipments
where Eid in (
	Select distinct Eid
	From Cops);


--F. return true and list all roles that appear in people in investigation and the role contains letter 'v'
----------------------------------------------------
Select RId
From PeopleInInvestigation
WHERE EXISTS( SELECT RId FROM Roles WHERE PeopleInInvestigation.Rid = Roles.Rid and role_name like '%v%')


--take all people in investigation that accepted to give their address or their email
----------------------------------------------------------------------------------------------------------
Select PId
From PeopleInInvestigation
WHERE EXISTS( SELECT PId FROM People WHERE PeopleInInvestigation.Pid = People.Pid and ((address is not null) or (email is not null))


--G. count all cops that are working in the same office
----------------------------------------------------------
SELECT count(*)
FROM (SELECT c.fname,c.lname,T.name, O.Oid
	FROM Cops C, Teams T, Office O
	WHERE c.Tid = t.Tid and t.Oid = o.Oid) AS tt 
Group BY tt.Oid;


--All males that have been involved into an accident
--------------------------------------------------------
Select m.CNP, m.fname as 'FirstName', m.lname as 'LastName'
From(
	SELECT *
	FROM People P
	WHERE CAST(LEFT(P.CNP,1) AS INT)%2<>0) M
ORDER BY m.CNP ASC;


--H.count cops in office and list the ones that have at least 3 people working in there
----------------------------------------------------------
SELECT count(tt.Oid) as 'CopsInOffice'
FROM (SELECT c.fname,c.lname,T.name, O.Oid
	FROM Cops C, Teams T, Office O
	WHERE c.Tid = t.Tid and t.Oid = o.Oid) AS tt 
Group BY tt.Oid
Having count(tt.Oid) >= 3*1.0;


--return the number of cops that have their salary greater than the average salary
-----------------------------------------------------------
SELECT COUNT(CNP), Salary*1.0
FROM Cops
GROUP BY Salary
HAVING Cops.Salary > (SELECT AVG(Salary) FROM Cops);


--return the number of cops that have their salary different than the minimum salary
-----------------------------------------------------------
SELECT COUNT(CCPid),salary
From CallCenterPeople
Group BY salary
Having CallCenterPeople.salary <>(SELECT MIN(salary) FROM CallCenterPeople);  


--counts teams in one office
----------------------------------------------------------------
SELECT Count(Tid),Oid
from Teams
Group by Oid


--I.
-------------------------------------------------------------------
SELECT fname,lname, CNP
FROM Cops
WHERE CNP = ANY(
		SELECT CNP
		FROM Cops
		WHERE CNP > '4%')

SELECT fname,lname, CNP
FROM Cops
WHERE CNP NOT IN(
		SELECT CNP
		FROM Cops
		WHERE CNP < '4%')

----------------------------------------------------------------------	
SELECT Tid, name
FROM Teams
WHERE Tid = ANY (
	SELECT c.Tid
	FROM Cops c, Teams t
	WHERE c.Tid = t.Tid and c.Salary <= (
		SELECT Min(Salary)
		FROM Cops))

SELECT Tid, name
FROM Teams
WHERE Tid IN(
	SELECT c.Tid
	FROM Cops c, Teams t
	WHERE c.Tid = t.Tid and c.Salary <= (
		SELECT Min(Salary)
		FROM Cops))


--
---------------------------------------------------------------
SELECT cc.CCPid, cc.fname,cc.lname,cc.salary
FROM CallCenterPeople cc
WHERE cc.salary < ALL (SELECT salary
					 FROM CallCenterPeople
					 WHERE salary > (10*100+500));

SELECT cc.CCPid, cc.fname,cc.lname,cc.salary
FROM CallCenterPeople cc
WHERE cc.salary < min((SELECT salary
					 FROM CallCenterPeople
					 WHERE salary > (10*100+500)));




--
-----------------------------------------------------------------
  
  SELECT CNP, fname,lname
FROM Cops 
WHERE salary > ALL(SELECT DISTINCT salary
				   FROM CallCenterPeople)

				     
  SELECT CNP, fname,lname
FROM Cops 
WHERE salary in (SELECT DISTINCT max(salary)
				   FROM CallCenterPeople)

Select * From CallCenterPeople
Select * From Calls
Select * From Cops
Select * From Equipments
Select * From Investigations
Select * From Office
Select * From People
Select * From PeopleInInvestigation
Select * From PoliceCars
Select * From PoliceStation
Select * From Roles
Select * From Teams
Select * From Usage