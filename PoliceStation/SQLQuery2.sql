use PoliceStation
go

--1.INSERT DATA INTO POLICE STATION TABLE
----------------------------------------------
--insert into PoliceStation
--values ('str. Florilor, nr. 27','Cluj-Napoca','Romania','0711222000');

--insert into PoliceStation
--values ('str. Decebal, nr. 26','Cluj-Napoca','Romania','0711222000');

--insert into PoliceStation
--values ('str. Observatorului, nr. 1','Cluj-Napoca','Romania','0711222000');

--insert into PoliceStation
--values ('str. Albac, nr. 15','Cluj-Napoca','Romania','0711222000');

--insert into PoliceStation
--values ('949 W. Maxwell St.','Chicago','USA','0711222000');

--insert into PoliceStation
--values ('4150 Grand River Avenue','Detroit','USA','0711222000');

--insert into PoliceStation
--values ('21 Yardley Road,','Acocks Green','UK','0711222000');


--MODIFY OFFICE TABLE
---------------------------------
--ALTER TABLE Office
--ADD name varchar(4);


--2.INSERT DATA IN OFFICE TABEL
---------------------------------------
--insert into Office
--values(1,'P1');

--insert into Office
--values(1,'P2');

--insert into Office
--values(1,'I1');

--insert into Office
--values(2,'P1');

--insert into Office
--values(2,'I2');

--insert into Office
--values(3,'I3');


--3.INSERT DATA INTO CALL CENTER PEOPLE
---------------------------------------------
--insert into CallCenterPeople
--values('5001118336673','Gigel','Marinarul',1);

--insert into CallCenterPeople
--values('2930908228746','Antonia','Isma',1);

--insert into CallCenterPeople
--values('1921009426590','Mark','Harmon',1);

--insert into CallCenterPeople
--values('5000530333031','Sean','Murray',2);

--insert into CallCenterPeople
--values('2890513031450','Pauley','Perrette',2);

--insert into CallCenterPeople
--values('2990425303679','Katrina','Law',3);

--insert into CallCenterPeople
--values('1871212243329','David','McCallum',3);

--4.INSERT INTO CALLS TABLE
-----------------------------
--insert into Calls
--values(1,'A Man Dressed as Spider-Man Is on a Robbery Spree');

--insert into Calls
--values(2,'REDACTED REDACTED REDACTED');

--insert into Calls
--values(3,'A lone hunter stalks the night, firing arrows into the Darkness. There is no hiding, no escape. In the distance, the beast falters, tethered to the void. The killing blow comes without hesitation, without mercy.');

--insert into Calls
--values(1,'forgotten to ask.’');

--insert into Calls
--values(2,' It.s getting bigger! Doesn.t anybody else see this?! It.s lighting up the sky around it...it.s huge! Oh god! Oh...oh, wait...911: Sir?BF: I am SO sorry...I.m not usually out this time of night, I just got off work late...that.s, that.s the sun...');

--insert into Calls
--values(3,'A lady tried to call an ambulance because she opened a package from Amazon at home and she was afraid that that her kid was about to have a major allergic reaction… From the packing peanuts. The kid was allergic to peanuts, and when her kid mentioned what they were called, she freaked out');

--insert into Calls
--values(1,'A drunk person called to report he was being harassed. Truth was he was being arrested by our officers for throwing pizza at people. All I heard in the background was one of my officers saying to him ‘That better not be our dispatcher on the phone’');

--insert into Calls
--values(2,'Paramedic here. I had a guy who picked his wart at 3 a.m. and it was bleeding. That’s it. That’s the story.');

--insert into Calls
--values(3,'Drunk woman called 911 because she couldn’t remember her phone passcode.');

--insert into Calls
--values(1,'A call from a girl in gym class at the local high school.She was in a panic, saying there was a squirrel on top of a telephone pole at the school and it wasn’t coming down.');

--insert into Calls
--values(2,'A guy calling just to argue that his crystal meth is legal because he made it with store-brought products with his own hard-earned money.');


--5.INSERT INTO EQUIPMENTS TABLE
-----------------------------------
--insert into Equipments
--values('echipament de vara');

--insert into Equipments
--values('echipament de iarna');

--insert into Equipments
--values('echipament de misiune');

--insert into Equipments
--values('echipament de call center');

--insert into Equipments
--values('echipament de teren');

--insert into Equipments
--values('echipament de sectie');

--insert into Equipments
--values('echipament de casa');

--6.INSERT INTO TEAMS TABLE
---------------------------------
--insert into Teams
--values(2,'TeamA'),
--(2,'TeamB'),(2,'TeamC'),(3,'TeamD'),
--(3,'TeamE'),(4,'TeamF'),(5,'TeamG'),

--insert into Teams
--values(10,'Nume');

--7.INSERT INTO COPS TABLE
----------------------------------
--insert into Cops
--values
--('5000616432840',1,2,'Mihai','Gheorghe','str Soarelui, nr 23, jud Vrancea','0712123123'),
--('6041201297192',2,1,'Ionela','Anghel','str Mare,nr 25,jud Prahova','0713133133'),
--('1970528289589',3,2,'Gigel','Marinarul','str Mica,nr 26, jud Olt','0780800800');

--1.UPDATE DATA FOR POLICE STATION TABLE
----------------------------------------------
--update PoliceStation
--set phone_number = '0711111111'
--where PSid = 2;

--update PoliceStation
--set phone_number = '0712123111'
--where PSid = 3;

--update PoliceStation
--set phone_number = '0701011011'
--where PSid = 4;

--update PoliceStation
--set city = 'Cluj'
--where city = 'Cluj-Napoca' AND (address LIKE '%2%' OR address LIKE '%1%');


--for some reason it still doesn't let me insert null values in the table...
--ALTER CALUMN TO ALLOW NULL VALUES
--------------------------------------------

--ALTER TABLE Equipments
--ALTER COLUMN equipment_name varchar(100) NULL;

--insert into Equipments
--values(null);

--2. UPDATE DATA FOR EQUIPMENT TABLE
---------------------------------------
--update Equipments
--set equipment_name = 'is null so delete it'
--where equipment_name is null;

--3. UPDATE DATA FOR CALL CENTER PEOPLE
-------------------------------------------
--update CallCenterPeople
--set 


--1.DELETE DATA FROM POLICE STATION TABLE
----------------------------------------------
--DELETE
--FROM PoliceStation
--WHERE PSid BETWEEN 8 AND 10; 

--DELETE
--FROM PoliceStation
--WHERE PSid > 10;

--2.DELETE DATA FROM EQUIPMENTS
---------------------------------------
--DELETE 
--FROM Equipments
--WHERE equipment_name in (
--	SELECT equipment_name 
--	FROM Equipments
--	WHERE equipment_name is not null AND equipment_name like '%delete%'
--);






--ALTER CALLS TABLE
---------------------
--ALTER TABLE Calls
--ADD call_dete date;


--ALTER COPS TABLE
---------------------
--ALTER TABLE Cops
--ADD cop_rank varchar(50) default 'Officer'


--UPDATE COPS TABLE FOR RANK
--------------------------------------

--update Cops
--set cop_rank = 'Detective'
--where Tid = 1 or Eid = 2;

--update Cops
--set cop_rank = 'Officer'
--where Tid = 2;

--update Cops
--set salary = 4000
--where cop_rank = 'Detective'

--update Cops
--set salary = 2500
--where cop_rank = 'Officer'

--INSERT DATA IN PEOPLE TABLE
-------------------------------------
--insert into People
--values('5000616432840','Mihai','Gheorghe',null,'0712123123',null),('1971030064240','Ion','Andrei',null,'075649820604',null),('6000227106557','Elisa','Niculescu',null,'0745561649',null),
--('2890924320896','Carla','Dobrica',null,'0789098234',null),('5010715071320','Andrei','Ursu',null,'0788179975',null),('5030901523678','Ovidiu','Munteanu',null,'0700231889',null),
--('2881103402654','Narcisa','Chirita',null,'0748679554',null),('6020212412451','Sonia','Tonica',null,'0711203649',null),('2900930394226','Madalina','Manole',null,'0702120345',null);

--ALTER USAGE TABLE
---------------------
--ALTER TABLE Usage
--ADD usage_date date;


--ALTER CALL CENTER PEOPLE TABLE
-----------------------------------

--ALTER TABLE CallCenterPeople
--ADD salary int default 1500;


--UPDATE CALL CENTER PEOPLE TABLE 
--------------------------------------

--update CallCenterPeople
--set salary = '1500';

--update CallCenterPeople
--set salary = '3000'
--where CAST(LEFT(CNP,1) AS INT) <=4;


--UPDATE CALLS TABEL FOR DATE
--------------------------------  

--update Calls
--set call_date = '12-Dec-2021'
--where CCPid%2=0

--update Calls
--set call_date = '15-Jan-2021'
--where CCPid%3=0

--update Calls
--set call_date = '08-Jun-2022'
--where CCPid%2<>0 and CCPid%3<>0


--update People
--set address = 'str. CafelutaDeDimi nr. 8'
--where Pid%2 =0 and Pid between 0 and 6;

--insert into Investigations
--values(1,'08-Jun-2022','blackmail'),(2,'15-Jan-2021','rape'),(3,'11-Feb-2020','lost money'),
--(3,'11-Feb-2020','blackmail'),(2,'08-Jun-2022','a'),(1,'15-Jan-2021','aa'),
--(1,'08-Jun-2022','slah'),(2,'15-Jan-2021','df,vfq;'),(5,'11-Feb-2020','dfskjbel');

--insert into Roles
--values('victim'),('witness'),('aggressor');

--insert into PeopleInInvestigation
--values(1,2,1),(2,1,1),(3,1,2)

--insert into PoliceCars
--values(1,'CJ04ABC','model1'),(2,'CJ17AAA','model2'),(1,'CJ99DLC','model3'),(2,'CJ12ALC','model4'),(1,'CJ04OPA','model2'),
--(1,'CJ78CVA','model5'),(2,'CJ84AZI','model2'),(4,'CJ10MOR','model4'),(3,'CJ05CAF','model3');

--DELETE
--FROM PoliceCars
--WHERE model like '%1%'

--insert into Usage
--values(1,11,'8-jan-2022'),(1,12,'8-jan-2022'),(2,13,'11-feb-2020'),(2,11,'8-sep-2022');
