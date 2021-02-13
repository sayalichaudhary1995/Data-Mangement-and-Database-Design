/*
PROJECT GROUP – 10
INFO 6210: HOSPITAL MANAGEMENT SYSTEM
DATABASE IMPLEMENTATION

Team Members:
●	Anjali Sajeevan
●	Deepika Kumari Jha
●	Madhurima Chatterjee
●	Sayali Nitin Chaudhary
●	Shreya Uppalapati
●	Pooja Singh Kumari
*/

/*   1.	DDL Statements  */
create database Group10;
USE GROUP10;

CREATE DATABASE GROUP10;
CREATE SCHEMA BloodBank;
CREATE SCHEMA COVID;
CREATE SCHEMA Departments;
CREATE SCHEMA Doctors;
CREATE SCHEMA Medicine;
CREATE SCHEMA Patient;
CREATE SCHEMA Test;


/* GROUP10.Departments.Department definition*/

CREATE TABLE Group10.Departments.Department
(DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
DepartmentName VARCHAR(40),
 NumberofDoctors int,
NumberofAssignedWards int);

/* GROUP10.Departments.Staff definition*/

create table Departments.Staff
(
    StaffID int identity(101,1) primary key,
    StaffCode varchar(5),
    StaffDesignation varchar(25),
    StaffFirstName varchar(20),
    StaffLastName varchar(20),
    ReportTo int,
    Gender varchar(10),
    JoiningDate date,
    Salary money,
    DateOfBirth date,
    Age as (datediff(yy, [DateOfBirth], getdate())),
    EmailAddress varchar(30),
    PhoneNumber bigint,
    State varchar(20),
    City varchar(20),
    ZipCode int
);

/* GROUP10.Departments.DepartmentStaff definition*/

create table Departments.DepartmentStaff
(
    DepartmentID int references Departments.Department(DepartmentID),
    StaffID int references Departments.Staff(StaffID)
    primary key (DepartmentID, StaffID)
);

/* GROUP10.Patient.Patient definition*/

create table Patient.Patient 
(
PatientId int identity(1,1) primary key not null,
Diagnosis varchar(200),
InPatientOrOutPatient varchar(50),
BloodGroup varchar(5),
EntryDate datetime,
ExitDate datetime,
Patient_FName varchar(20),
Patient_LName varchar(20),
Gender varchar(10),
Guardian_FName varchar(20),
Guardian_LName varchar(20),
PhoneNumber bigint,
EmailAddress nvarchar(30),
StreetName varchar(30),
City varchar(20),
Zipcode int,
DateOfBirth date NULL,
Symptoms varchar(100) NULL
);

/* GROUP10.Doctors.Doctor definition*/

CREATE TABLE Group10.Doctors.Doctor
(DoctorID INT IDENTITY(76,1) PRIMARY KEY, 
DepartmentID INT REFERENCES Departments.Department(DepartmentID),
DoctorLastName VARCHAR(80),
DoctorFirstName VARCHAR(80),
Specialization VARCHAR(80),
Gender VARCHAR(80),
EmailAddress VARCHAR(80),
StreetName VARCHAR(80),
City VARCHAR(80),
ZipCode INT ,
ContactNumber BIGINT,
WorkingHours Float,
Salary Money,
DateofBirth Datetime,
Age as DATEDIFF(hour,DateofBirth,GETDATE())/8766);
GO
 
/* GROUP10.Medicine.Medicine definition*/

Create table Medicine.Medicine
(
MedicineID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
MedicineName VARCHAR(50) NOT NULL,
DrugClass VARCHAR(40) ,
Symptoms VARCHAR(100),
Cost MONEY NOT NULL,
QuantityAvailable INT
);

/* GROUP10.Medicine.PatientMedicine definition*/

Create table Medicine.PatientMedicine
(
PatientID int NOT NULL
REFERENCES Patient.Patient(PatientID),
MedicineID int NOT NULL
REFERENCES Medicine.Medicine(MedicineID),
CONSTRAINT PKPatientMedicine PRIMARY KEY CLUSTERED
(PatientID, MedicineID)
);

/* GROUP10.COVID.COVID19Department definition*/

Create table COVID.COVID19Department
(
StaffID INT NOT NULL
REFERENCES Departments.Staff(StaffID),
DoctorID INT NOT NULL
REFERENCES Doctors.Doctor(DoctorID),
CONSTRAINT PKStaffDoctor PRIMARY KEY CLUSTERED
 (StaffID, DoctorID),
 InventoryCode INT NOT NULL
 REFERENCES COVID.Inventory(InventoryCode)
);

/* GROUP10.COVID.Inventory definition*/

CREATE TABLE [COVID].[Inventory]
(
	[InventoryCode] [int] NOT NULL primary key ,
	[InventoryType] [varchar](40),
	[Brand] [varchar](40),
	[StockQuantity] [int]
);

/* GROUP10.Patient.Insurance definition*/
 
 create table Patient.Insurance
 (
 InsuranceID int  primary key not null,
 PatientID INT REFERENCES Patient.Patient(PatientID),
 [Provider] varchar(20),
 Coverage_Amount money
 );

/* GROUP10.Patient.PatientRegistration definition*/

Create table Patient.PatientRegistration
(
AppointmentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY ,
DoctorID INT NOT NULL
REFERENCES Doctors.Doctor(DoctorID),
PatientID INT NOT NULL
REFERENCES Patient.Patient(PatientID),
Date datetime DEFAULT Current_Timestamp
);

/*  GROUP10.Patient.PatientTest definition*/

CREATE TABLE GROUP10.Patient.PatientTest (
	PatientID int References Patient.Patient(PatientID),
	TestID int references Test.TestDetails(TestID),
	StaffID int  REFERENCES Departments.Staff(StaffID),
	TestResultDescription varchar(50),
	PatientTestDate datetime NULL,
	CONSTRAINT PKPatientTest PRIMARY KEY CLUSTERED
	(TestID, PatientID)
) ;

/* GROUP10.Patient.WardRooms definition*/

create table Patient.WardRooms
 (
  RoomID int identity(101,1) primary key not null,
  PatientID INT REFERENCES Patient(PatientID),
  [Floor] varchar(10),
  [Type] varchar(20),
 );

/* GROUP10.Test.TestDetails definition*/

create table Test.TestDetails
(
    TestID int  primary key NOT NULL,
	TestName varchar(40) ,
	TestDescription varchar(40) 
);


/* GROUP10.BloodBank.AcceptenceRecord definition*/

CREATE TABLE GROUP10.BloodBank.AcceptenceRecord (
	AcceptanceRecordID int primary key NOT NULL,
	PatientID int references Patient.Patient(PatientID) ,
	BloodBankID int references BloodBank.BloodBank(BloodBankID) ,
	AcceptanceDate datetime ,
	AcceptancePlace varchar(30) ,
	AcceptedBloodGroup varchar(5) ,
	AcceptedBloodAmount decimal(10,4) 
    );

/* GROUP10.BloodBank.BloodBank definition*/

CREATE TABLE GROUP10.BloodBank.BloodBank (
	BloodBankID int primary key NOT NULL,
	BloodBankName varchar(30) ,
	State varchar(30) ,
	City varchar(30) ,
	Zipcode varchar(30) 
 	);

/* GROUP10.BloodBank.BloodDonationRecord definition*/

CREATE TABLE GROUP10.BloodBank.BloodDonationRecord (
	DonationRecordID int primary key NOT NULL,
	BloodBankID int references BloodBank.BloodBank(BloodBankID),
	DonorName varchar(30),
	DonorState varchar(30),
	DonorCity varchar(30) ,
	DonorZIPcode varchar(6) ,
	DonationDate datetime ,
	DonationBloodGroup varchar(5),
	[BloodAmount(in ml)] decimal(10,4) 
	);

/* GROUP10.BloodBank.BloodStock definition*/

CREATE TABLE GROUP10.BloodBank.BloodStock (
	StockID int primary key NOT NULL,
	BloodBankID int references BloodBank.BloodBank(BloodBankID),
	BloodGroup varchar(5) ,
	Status varchar(20),
	Quantity decimal(10,4) ,
	BestBefore datetime 
	);

/* VIEWS*/

/* COVID.COVID_Patient source view*/

create view COVID.COVID_Patient as
select Patient_FName,
	   Patient_LName,
	   StreetName,
	   City,
	   Zipcode,
	   Age
	   from Patient.Patient
	   where Diagnosis='COVID';

select * from covid.COVID_Patient

/*  COVID.COVID_Analysis view*/    

create view COVID.COVID_Analysis as select p.Patientid, Age, 
p.Symptoms,p.Diagnosis, MedicineName from
patient.Patient p join
medicine.PatientMedicine pm on p.patientid=pm.patientid
join medicine.Medicine m on pm.MedicineID=m.MedicineID
where p.Diagnosis='COVID'
GO

select * from covid.COVID_Analysis

/* Departments.StaffAllocations source view*/

create view Departments.StaffAllocations
as select distinct s.StaffFirstName, s.StaffLastName,
stuff((select ', '+rtrim(cast(d.DepartmentName as char))
	from Departments.Department d join Departments.DepartmentStaff ds
	on d.DepartmentID = ds.DepartmentID
	where StaffID = ds1.StaffID
	group by d.DepartmentName 
	order by d.DepartmentName 
	for xml path ('')) , 1, 2, '') as Allocations
from Departments.Staff s join Departments.DepartmentStaff ds1
on s.StaffID = ds1.StaffID;

select * from Departments.StaffAllocations
select* from Patient.Patient

/* Functions*/

/* calculate_PatientAge - function*/

CREATE function dbo.cal_PatientAge(@PatientID int)
returns int
as 
begin
declare @Age int =(select DATEDIFF(hour,DateOfBirth,GETDATE())/8766 from Patient.Patient
where patientID=@patientID);
SET @Age = ISNULL(@Age, 0);
      RETURN @Age;
END

/* InPatient_Constr - function*/

create function dbo.InPatient_Constr(@patientID int)
returns smallint
as
begin
declare @Count smallint =0;
select @Count= count(inpatientoroutpatient)
from patient.patient
where inpatientoroutpatient='OutPatient' and PatientId=@patientID;
return @count;
end

/* RoomAvailability- function*/

create function dbo.RoomAvailability(@PatientID int)
returns varchar(50)
as
begin
declare  @Sts varchar(50)= (select  
case  when exitdate is null then 'Not Available'
else 'Available'
end as [Status]
from Patient.Patient
where PatientID=@PatientID);
return @Sts;
end

/* ENCRYPTION*/

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Group10member6';

CREATE CERTIFICATE TestCertificate
WITH SUBJECT = 'Group 10 project certificate',
EXPIRY_DATE = '2022-10-31';

CREATE SYMMETRIC KEY TestSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE TestCertificate;

ALTER TABLE Group10.Doctors.Doctor
ADD Salary_encrypt varbinary(MAX)

OPEN SYMMETRIC KEY TestSymmetricKey
    	DECRYPTION BY CERTIFICATE TestCertificate;

UPDATE Group10.Doctors.Doctor
    	SET Salary_encrypt = EncryptByKey (Key_GUID('TestSymmetricKey'), convert(varchar(max),Salary))
    	FROM Group10.Doctors.Doctor;
    	GO

CLOSE SYMMETRIC KEY TestSymmetricKey;
GO
select*from doctors.Doctor

/*Dropping Original Table*/

ALTER TABLE Group10.Doctors.Doctor DROP COLUMN Salary;
GO

/*Renaming the Salary _encrypt to salary*/

EXEC sp_rename 'Group10.Doctors.Doctor.Salary_encrypt', 'Salary', 'COLUMN';

/*DECRYPTION*/

OPEN SYMMETRIC KEY TestSymmetricKey
 DECRYPTION BY CERTIFICATE TestCertificate;

select Doctors.Doctor.DoctorFirstName, DECRYPTBYKEY(Salary)
from Doctors.Doctor;

SELECT Salary AS 'Encrypted data',
CONVERT(MONEY, CONVERT(VARCHAR(max), DECRYPTBYKEY(Salary)))
 FROM GROUP10.Doctors.Doctor;

/*Closing key*/

-- Close the symmetric key
CLOSE SYMMETRIC KEY TestSymmetricKey;

/*Select all statements*/
use group10;
select * from Doctors.Doctor
select * from Departments.Department
select * from Departments.Staff
select * from Departments.DepartmentStaff
select * from Patient.Patient
select * from Patient.PatientRegistration
select * from Patient.Insurance
select * from Patient.PatientTest
select * from Patient.WardRooms
select * from Medicine.Medicine
select * from Medicine.PatientMedicine
select * from Test.TestDetails
select * from COVID.COVID19Department
select * from covid.Inventory
select * from BloodBank.AcceptenceRecord
select * from BloodBank.BloodBank
select * from BloodBank.BloodDonationRecord
select * from BloodBank.BloodStock


/*DML(INSERT Statements)*/

/*GROUP10.Departments.Department */

insert  into Group10.Departments.Department (DepartmentName,NumberofDoctors,NumberofAssignedWards) 
values ('Accident and emergency', '1', '4'),
		('Anesthetics','1','2'),
		('Cardiology','2','3'),
		('Intensive Care Unit','2','3'),
		('Diagnostic imaging','1','1'),
		('Ear nose and throat','1','1'),
		('Surgery','3','5'),
		('Gynecology','2','5'),
		('Pediatrics','1','1'),
		('Neurology','2','2'),
		('Oncology','1','4'),
		('Orthopedics','1','2'),
		('Dermatology','1','1'),
		('Laboratory','1','2');

/*GROUP10.Departments.Staff */

INSERT INTO GROUP10.Departments.Staff (StaffCode,StaffDesignation,StaffFirstName,StaffLastName,ReportTo,Gender,JoiningDate,Salary,DateOfBirth,EmailAddress,PhoneNumber,State,City,ZipCode) VALUES 
('ADM','Administrator','Annalise','Keating',107,'Female','2020-03-14',2000.0000,'1985-04-25','anna@gmail.com',9876123451,'Maharashtra','Mumbai',111233)
,('NUR','Nurse','Wes','Gibbins',104,'Male','2017-12-14',4350.0000,'1984-03-14','wes@gmail.com',9478942605,'Delhi','New Delhi',113453)
,('JAN','Janitor','Frank','Delfino',104,'Male','2012-03-20',1240.0000,'1983-02-12','frank@gmail.com',9349539537,'Tamil Nadu','Chennai',115673)
,('HNUR','Head Nurse','Laurel','Castillo',101,'Female','2003-09-12',3450.0000,'1982-07-14','laurel@gmail.com',9096427495,'Kerala','Trivandrum',116783)
,('NUR','Nurse','Asher','Millstone',104,'Male','2013-05-26',3420.0000,'1989-05-26','asher@gmail.com',9052794601,'Andhra Pradehs','Hyderabad',112343)
,('JAN','Janitor','Bonnie','Winterbottom',101,'Female','2019-07-14',2310.0000,'1987-09-12','bonnie@gmail.com',9790542794,'West Bengal','Kolkata',112343)
,('HADM','Administrator','Oliver','Hampton',NULL,'Male','2001-02-12',1120.0000,'1986-03-20','oliver@gmail.com',9965237804,'Uttar Pradesh','Lucknow',115503)
,('HNUR','Head Nurse','Gabriel','Maddox',101,'Male','2000-03-14',2280.0000,'1985-12-14','gabriel@gmail.com',9444477738,'Himachal Pradesh','Shimla',115683)
,('RECEP','Receptionist','Connor','Walsh',101,'Male','2019-12-16',2340.0000,'1981-02-25','connor@gmail.com',9853961694,'Rajasthan','Jaipur',118913)
,('NUR','Nurse','Michaela','Pratt',108,'Female','2007-02-23',5780.0000,'1988-12-16','michaela@gmail.com',9369417052,'Jammu','Srinagar',113453)
;
INSERT INTO GROUP10.Departments.Staff (StaffCode,StaffDesignation,StaffFirstName,StaffLastName,ReportTo,Gender,JoiningDate,Salary,DateOfBirth,EmailAddress,PhoneNumber,State,City,ZipCode) VALUES 
('HLAB','Pathologist','Anna','Jha',101,'Female','2000-03-14',1120.0000,'1987-09-12','Anna@gmail.com',7896345223,'Maharashtra','Mumbai',400011)
,('LAB','Pathologist','Michael','John',111,'Male','2019-12-16',1120.0000,'1989-05-26','Michael@gmail.com',8889966543,'Maharashtra','Mumbai',400011)
,('LAB','Pathologist','Peter','Pan',111,'Male','2000-03-14',1120.0000,'1987-09-12','Peter@gmail.com',9988776543,'Maharashtra','Mumbai',400011)
;

/*GROUP10.Departments.DepartmentStaff */

INSERT INTO GROUP10.Departments.DepartmentStaff (DepartmentID,StaffID) VALUES 
(1,101)
,(1,102)
,(1,103)
,(1,104)
,(1,105)
,(1,106)
,(1,107)
,(1,108)
,(2,101)
,(2,102)
;
INSERT INTO GROUP10.Departments.DepartmentStaff (DepartmentID,StaffID) VALUES 
(2,103)
,(2,104)
,(2,109)
,(3,101)
,(3,105)
,(3,106)
,(3,107)
,(3,108)
,(3,109)
,(3,110)
;
INSERT INTO GROUP10.Departments.DepartmentStaff (DepartmentID,StaffID) VALUES 
(4,102)
,(4,103)
,(4,104)
,(4,105)
,(4,106)
,(4,107)
,(5,101)
,(5,102)
,(5,103)
,(5,104)
;
INSERT INTO GROUP10.Departments.DepartmentStaff (DepartmentID,StaffID) VALUES 
(5,105)
,(5,106)
,(5,107)
,(5,108)
,(5,109)
,(5,110)
,(6,101)
,(6,102)
,(6,103)
,(6,104)
;
INSERT INTO GROUP10.Departments.DepartmentStaff (DepartmentID,StaffID) VALUES 
(6,105)
,(6,106)
,(6,107)
,(6,108)
,(6,109)
,(6,110)
,(7,101)
,(7,102)
,(7,103)
,(7,104)
;
INSERT INTO GROUP10.Departments.DepartmentStaff (DepartmentID,StaffID) VALUES 
(7,105)
,(7,106)
,(7,109)
,(7,110)
,(8,101)
,(8,102)
,(8,103)
,(8,104)
,(8,105)
,(8,106)
;
INSERT INTO GROUP10.Departments.DepartmentStaff (DepartmentID,StaffID) VALUES 
(8,107)
,(8,108)
,(9,101)
,(9,102)
,(9,103)
,(9,104)
,(9,109)
,(10,101)
,(10,105)
,(10,106)
;
INSERT INTO GROUP10.Departments.DepartmentStaff (DepartmentID,StaffID) VALUES 
(10,107)
,(10,108)
,(10,109)
,(10,110)
,(11,102)
,(11,103)
,(11,104)
,(11,105)
,(11,106)
,(11,107)
;
INSERT INTO GROUP10.Departments.DepartmentStaff (DepartmentID,StaffID) VALUES 
(12,101)
,(12,102)
,(12,103)
,(12,104)
,(12,105)
,(12,106)
,(12,107)
,(12,108)
,(12,109)
,(12,110)
;
INSERT INTO GROUP10.Departments.DepartmentStaff (DepartmentID,StaffID) VALUES 
(13,101)
,(13,102)
,(13,103)
,(13,104)
,(13,105)
,(13,106)
,(13,107)
,(13,108)
,(13,109)
,(13,110)
;
INSERT INTO GROUP10.Departments.DepartmentStaff (DepartmentID,StaffID) VALUES 
(14,101)
,(14,102)
,(14,103)
,(14,104)
,(14,105)
,(14,106)
,(14,109)
,(14,110)
;


/*GROUP10.Patient.Patient */

INSERT INTO GROUP10.Patient.Patient (Diagnosis,InPatientOrOutPatient,BloodGroup,EntryDate,ExitDate,Patient_FName,Patient_LName,Gender,Guardian_FName,Guardian_LName,PhoneNumber,EmailAddress,StreetName,City,Zipcode,DateOfBirth,Symptoms) VALUES 
('Diabetes','OutPatient','A+','2019-11-19 11:00:09.000','2019-11-19 13:00:09.000','Ria','Patel','Female','Rohan','Patel','7854658936','ria.rohan@gmail.com','Milap Nagar','Mumbai',4000021,'1998-02-02','NULL')
,('Back pain','OutPatient','B+','2019-11-19 13:00:09.000','2019-11-19 14:00:09.000','Ashish','Naik','male','Rajesh','Naik','8899447711','Ashish.Naik@gmail.com','Tilak Nagar','Mumbai',4000022,'1985-01-05','NULL')
,('Leg Fracture','InPatient','B+','2019-11-20 10:30:00.000','2019-11-30 10:30:00.000','Ashok','Pai','male','Raj','Pai','7899447711','Ashish.Naik@gmail.com','Tilak Nagar','Mumbai',4000022,'1970-01-05','Leg pain and Swelling')
,('Cataract','InPatient','O-','2019-11-20 10:30:00.000','2019-11-20 11:00:09.000','Neha','Patil','Female','Ria','Patil','7899584711','Neha.Patil@gmail.com','Lotus Colony','Mumbai',4000022,'1975-07-05','Eye pain and infection')
,('Obesity','OutPatient','B+','2020-01-19 11:00:09.000','2020-01-19 12:00:09.000','Juhi','Patel','Female','Saurabh','Patel','7755123652','Juhi@gmail.com','Vasant Vihar','Mumbai',421578,'1995-01-04','Difficulty in physical activity')
,('Anxiety','OutPatient','A-','2020-01-20 12:00:09.000','2020-01-20 11:00:09.000','Sunil','Ahuja','Male','Meena','Ahuja','7845129865','Sunil@gamil.com','Dokali Naka','Mumbai',4000036,'1994-12-08','Chest pain')
,('Allergy','OutPatient','O+','2020-01-22 10:00:09.000','2020-01-21 11:00:09.000','Varsh','Katdar','Female','Sid','Katdar','8945326566','Varsh@gamil.com','Sargar Viahr','Mumbai',4000022,'1997-01-12','Eye infection')
,('COVID','InPatient','A+','2020-05-05 11:00:09.000','2020-05-14 11:30:09.000','Neha','Patil','Female','Monica','Patil','7755331155','Neha@gamil.com','Navi Vashi','Mumbai',4000033,'1995-01-07','Fever Dry cough and Tiredness')
,('COVID','InPatient','B+','2020-05-07 11:00:09.000','2020-05-13 11:00:09.000','Garima','Mehta','Female','Chand','Mehta','8844663322','Garima@gamil.com','Chaitra Nagar','Mumbai',4000035,'1990-01-08','Fever Dry cough and Tiredness')
,('Asthma','InPatient','B+','2020-06-10 13:00:09.000','2020-06-15 11:00:09.000','Mani','Pati','Male','Vardhak','Pati','9865327845','Mani@gamil.com','Hardhik Colony','Mumbai',4000032,'1965-01-09','Shortness of breath')
,('COVID','InPatient','A+','2020-06-25 13:00:09.000','2020-07-02 11:00:09.000','Rushikesh','Thombre','Male','Kishor','Thombre','8765324815','Rushikesh@gamil.com','RT Road','Mumbai',4000033,'1970-02-10','Fever With Dry cough and Tiredness')
,('Urinary tract infection','OutPatient','B+','2020-07-02 11:00:09.000','2020-07-02 11:45:09.000','Amit','Komsar','Male','Jagdish','Komsar','9487653225','Amit@gamil.com','GP Road','Mumbai',4000034,'1998-01-11','A burning sensation when urinating')
,('Pain in joint','OutPatient','O+','2020-07-16 11:00:09.000','2020-07-16 11:00:09.000','Amrit','Bhangale','Male','Manish','Bhangale','7746859123','Amrit@gamil.com','Sudhama Nagar','Mumbai',4000035,'1997-01-12','joint swelling')
,('COVID','InPatient','A+','2020-07-22 11:00:09.000','2020-07-29 11:45:09.000','Sanjay','Poddar','Male','Shraddha','Poddar','7595153599','Sanjay@gamil.com','Lotus Colony','Mumbai',4000021,'1989-01-13','Fever Dry cough and Tiredness')
,('COVID','InPatient','A+','2020-07-23 11:00:09.000','2020-07-30 11:45:09.000','Priya','Naik','Female','Manisha','Naik','7898486815','Priya@gamil.com','Lotus Colony','Mumbai',4000021,'1999-01-14','Fever With  Dry cough')
,('COVID','InPatient','A+','2020-07-23 11:00:09.000','2020-01-29 11:45:09.000','Poonam','Oak','Female','Kanika','Oak','8485861535','Poonam@gamil.com','Lotus Colony','Mumbai',4000021,'2000-02-15','Fever With  Tiredness')
,('COVID','InPatient','A+','2020-07-24 11:00:09.000','2020-07-31 11:45:09.000','Asfiya','Modak','Female','Karthik','Modak','9475845748','Asfiya@gamil.com','Chaitra Nagar','Mumbai',4000035,'2000-07-16','Fever With Dry cough and Tiredness')
,('COVID','InPatient','A+','2020-08-04 11:00:09.000','2020-08-01 11:45:09.000','Asha','Mali','Female','Karthik','Mali','9475524748','Asha@gamil.com','Chaitra Nagar','Mumbai',4000035,'1995-07-16','Fever With Dry cough and Tiredness')
,('Hemophilia','OutPatient','A+','2020-07-24 12:00:09.000','2020-07-24 13:00:09.000','Anamika','Jha','Female','Ishwari ','Jha','9827632453','Anamika10@gmail.com','Milap Nagar','Mumbai',4000021,'1997-01-12','Blood in stool and Urine')
,('Cancer','InPatient','A+','2020-07-25 12:00:09.000','2020-07-25 13:00:09.000','Tina','Jha','Female','Dhirendra','Jha','9988776654','Tina@gmail.com','Milap Nagar','Mumbai',4000035,'2000-07-16','Bleeding, Bruising,Mouth ulcer, shortness of brath')
,('Anemia','InPatient','A+','2020-07-25 15:00:09.000','2020-07-25 16:00:09.000','Anjali','Gupta','Female','Rajdeep','Gupta','9988776623','Anjaligupta@gmail.com','Sudhama Nagar','Mumbai',4000021,'1997-01-12','Dizizness, Headache, Fatigue')
,('Anemia','InPatient','O+','2020-07-26 11:00:09.000','2020-07-26 12:00:09.000','Prashant','Gupta','Male','Shraddha','Gupta','9998867890','GuptaPrashant@gmail.com','Sudhama Nagar','Mumbai',4000035,'2000-07-16','Weakness , headache, Fatigue')
,('Cancer','OutPatient','AB+','2020-07-27 11:00:09.000','2020-07-27 12:00:09.000','Virendra','Gupta','Male','Deepak','Gupta','7865432198','Virendra@gmail.com','Lotus Colony','Mumbai',4000021,'1997-01-12','Diziness, loss of apetitie, bleeding')
,('Cancer','OutPatient','AB-','2020-07-28 11:00:09.000','2020-07-28 13:00:09.000','Prashant','Tripathi','Male','Priyank','Tripathi','7865432197','Prashanttripathi@gmail.com','Lotus Colony','Mumbai',4000035,'2000-07-16','Swollen lymph,nosebleed,wieght loss')
,('Anemia','OutPatient','AB+','2020-07-29 11:00:09.000','2020-07-29 12:00:09.000','Meenakshi','Kulkarni','Female','Brijesh','Kulkarni','9865432197','Meenakshi@gmail.com','Sudhama Nagar','Mumbai',4000021,'1997-01-12','Brittle nails,headcahe,Pallor')
,('Road Accident','OutPatient','A+','2020-07-30 11:00:09.000','2020-07-30 13:00:09.000','Yadvendra','Chadda','Male','Manish','Chadda','9998867891','Yadvendra20@gmail.com','Chaitra Nagar','Mumbai',4000035,'2000-07-16','Heavy bleeding due to injury in leg')
,('Road Accident','OutPatient','O+','2020-08-25 11:00:09.000','2020-08-25 12:00:09.000','Sakshi','Sharma','Female','Shraddha','Sharma','9998867892','Sakshi45@gmail.com','Chaitra Nagar','Mumbai',4000021,'1997-01-12','Heavy bleeding due to injury in arms and shoulder')
,('Hemophilia','OutPatient','O+','2020-08-26 11:00:09.000','2020-08-26 12:00:09.000','Soumya','Patel','Female','Manisha','Patel','9998867791','Soumya456@gmail.com','Chaitra Nagar','Mumbai',4000035,'1997-01-12','Internal bleeding, nose bleed,swollen joints')
,('Hemophilia','InPatient','AB+','2020-08-27 11:00:09.000','2020-08-27 12:00:09.000','Leela','Patil','Female','Neel','Mani','7865432199','Leela10@gmail.com','Mumbai','Mumbai',4000021,'1997-01-12','Internal bleeding,swollen joints')
;

/*GROUP10.Doctors.Doctor */

INSERT INTO GROUP10.Doctors.Doctor(DepartmentID,DoctorLastName,DoctorFirstName,Specialization,Gender,EmailAddress ,StreetName ,City ,ZipCode,ContactNumber,WorkingHours,Salary ,DateofBirth)
values 
(1,'Ramesh','Suresh','Emergency medicine','Male','Suresh@gmail.com','Altamount Road','Mumbai',160003,9847870450,10,50000,'1980-04-02'),
(5,'Sasankan','Akhilesh','Radiologist','Male','Akhilesh@gmail.com','Dalal Street','NewDelhi',220034,9847543250,8,60000,'1988-07-02'),
(4,'Sajeevan','Anjali','Intensivist','Female','Anjali@gmail.com','Park Street','Mumbai',140125,9847870321,10,60000,'1990-06-06'),
(9,'Kumari','Deepika','Pediatrician','Female','Deepika@gmail.com','Bandstand Promenade','Rajasthan',360036,9847345660,8,90000,'1979-02-04'),
(14,'Chatterjee','Madhurima','Pathologist','Female','Madhurima@gmail.com','Marine Drive','Kerala',620668,9847765356,10,70000,'1980-06-02'),
(2,'Nitin','Sayali','Anesthesiologist','Female','Sayali@gmail.com','Carter Road Promenade','Mumbai',160047,9847898789,10,70000,'1977-07-30'),
(10,'Uppalapati','Sreya','Neurologist','Female','Sreya@gmail.com','Chembur Causeway','Mumbai',160017,9847899896,10,100000,'1975-08-04'),
(8,'Singh','Pooja','Gynecologist','Female','Pooja@gmail.com','Mall Road','TamilNadu',545457,9847222444,10,120000,'1977-09-05'),
(13,'Sheikh','Hashim','Dermatologist','Male','Hashim@gmail.com','Breach Candy','Mumbai',160101,9847546546,8,70000,'1980-01-01'),
(3,'Dalmaida','Lorraine','Cardiologist','Female','Lorraine@gmail.com','Nana Chowk','Assam',887888,9847998898,10,150000,'1984-05-1'),
(11,'Sajeevan','Anjana','Oncologists','Female','Anjana@gmail.com','Colaba Causeway','Mumbai',160012,9847345654,10,150000,'1986-12-06'),
(6,'Mohammad','Enas','Otolaryngologist','Female','Enas@gmail.com','P L Lokhande Marg','AndhraPradesh',767767,9847434343,10,90000,'1979-01-02'),
(7,'Radhakrishnan','Akhil','Cardiac surgeon','Male','Akhil@gmail.com','Mahim Causeway','Mumbai',160002,9847877766,10,150000,'1980-04-02'),
(7,'Jayashanker','Veena','General surgeon','Female','Veena@gmail.com','Bidhan Sarani','Hydrabad',454545,9847334465,10,120000,'1978-04-06'),
(4,'Rajput','Akshay','Intensivist','Male','Akshay@gmail.com','Sion Causeway','Mumbai',160002,9847766786,10,60000,'1991-01-06'),
(3,'Athul','Theertha','Cardiologist','Female','Theertha@gmail.com','Princess Street','Mumbai',140133,9847887788,10,150000,'1969-01-09'),
(7,'Balu','Anakha','General surgeon','Female','Anakha@gmail.com','Aurobindo Sarani','Goa',323205,9847766656,10,120000,'1980-08-06'),
(10,'Sankar','Sajeevan','Neurologist','Female','Sajeevan@gmail.com','Lady Jamshetjee Road','Mumbai',160102,9847087755,10,100000,'1982-02-09') ,
(8,'Menon','Aneesh','Gynecologist','Male','Aneesh@gmail.com','Jeejabai Bhosle Marg','Mumbai',160101,9847223354,10,120000,'1981-01-02') ,
(12,'Abbas','Tarana','Orthopedic','Female','Tarana@gmail.com','Lamington Road','Karnataka',820554,9847656534,8,90000,'1983-04-02');

/*GROUP10.Patient.Insurance*/

INSERT INTO GROUP10.Patient.Insurance (InsuranceID,PatientID,Provider,Coverage_Amount) VALUES 
(101,2,'HDFC',100000.0000)
,(102,5,'ICICI',150000.0000)
,(103,7,'Apollo Munich Health',200000.0000)
,(104,6,'Max Bupa Health',100000.0000)
,(105,3,'Religare Health',200000.0000)
,(106,4,'ICICI',500000.0000)
,(107,8,'Cigna TTK Health',200000.0000)
,(108,9,'Star Health & Allied',50000.0000)
,(109,11,'Bajaj Allianz',200000.0000)
,(110,13,'HDFC',80000.0000)
,(111,10,'Apollo Munich Health',750000.0000)
;

/*GROUP10.COVID.Inventory*/

INSERT INTO GROUP10.COVID.Inventory (InventoryCode,InventoryType,Brand,StockQuantity) VALUES 
(100,'N95 respirators','Honeywell',10000)
,(101,'Face Shield','Honeywell',5000)
,(102,'Surgical masks','3M',5000)
,(103,'Latex Gloves','Chefs Star',5000)
,(104,'Nitrile Gloves','ProCure',5000)
,(105,'Goggles','Oriley ORSGR2',3000)
,(106,'Hand Sanitizers','Dettol',20000)
,(107,'PPE Kits','Smart Care',1000)
,(108,'Infrared Thermometer','Fujitech',5000)
,(109,'Syringe','Dispo Van',10000)
,(110,'Ventilators',NULL,2000)
,(111,'Beds',NULL,2000)
,(112,'Oximeter',NULL,4000)
,(113,'Hand Wash','Dettol',10000)
,(114,'Wipes','Dettol',10000)
;

/*GROUP10.COVID.COVID19Department */

INSERT INTO GROUP10.COVID.COVID19Department (StaffID,DoctorID,InventoryCode) VALUES 
(101,77,102)
,(102,78,103)
,(103,76,106)
,(104,79,107)
,(105,81,114)
,(106,83,110)
,(107,85,113)
,(108,91,104)
,(109,92,105)
,(110,94,112)
;

/* GROUP10.Medicine.Medicine */
select * from Medicine.Medicine
INSERT INTO GROUP10.Medicine.Medicine (MedicineName,DrugClass,Symptoms,Cost,QuantityAvailable) VALUES 
('Ado-Trastuzumab Emtansine','Antineoplastic agent','Irritation or dimpling of breast skin, New lump in the breast or underarm (armpit)',15000.0000,1056)
,('Claritin','Antihistamines','Rash, Localized Itching, Congestion',20.0000,6504)
,('Ferralet 90','Iron Products','Paleness of skin, Fast or irregular heartbeat,  light-headedness',2542.0000,9655)
,('Integra Plus','Iron Products','Paleness of skin, Fast or irregular heartbeat,  light-headedness',254.0000,4535)
,('Benzodiazepines','Psychoactive drugs ','Restlessness, Excess Worrying, Feeling Agitated, Fatigue',985.0000,4529)
,('Tricyclic antidepressants','Antidepressant','Restlessness, Excess Worrying, Feeling Agitated, Fatigue',3655.0000,3245)
,('Amoxicillin','Antibiotics','Drycough, Fever,Tiredness',488.0000,1485)
,('Doxycycline','Antibiotics','Drycough, Fever,Tiredness',965.0000,3245)
,('Cephalexin','Antibiotics','Drycough, Fever,Tiredness',458.0000,7895)
,('Clindamycin','Antibiotics','Drycough, Fever,Tiredness',964.0000,4569)
,('Diclofenac','Painkillers','Body Pain,Nausea, Vomiting',3684.0000,1414)
,('Metoclopramide','Prokinetic agents','Severe pain, which may worsen with movement, Obvious deformity or shortening of the affected leg',4655.0000,2000)
,('Amicar','Vasopressins','Many large or deep bruises, Blood in your urine or stool,Nosebleeds without a known cause',456.0000,2478)
,('Levofloxacin','Antibiotics','A strong, persistent urge to urinate, A burning sensation when urinating',5862.0000,2587)
,('Cipro','Antibiotics','A strong, persistent urge to urinate, A burning sensation when urinating',576.0000,2546)
,('Ciprofloxacin','Antibiotics','A strong, persistent urge to urinate, A burning sensation when urinating',964.0000,3666)
,('Ibuprofen','NSAIDs','Severe pain, worsen with movement, shortening of the affected leg',1524.0000,3542)
,('Naproxen sodium','NSAIDs','Joint redness, Joint swelling, Locking of the joint,Stiffness',1526.0000,2879)
,('Cetilistat','Lipase inhibitor','Breathlessness, Increased sweating, Feeling very tired',3000.0000,2546)
,('Rimonabant','Anorectic anti-obesity','Breathlessness, Increased sweating, Feeling very tired',4789.0000,657)
,('Sibutramine','Stimulant','Breathlessness, Increased sweating, Feeling very tired',6324.0000,6975)
,('Meglitinides',' Diabetes type 2','Urinating often, Feeling very thirsty, Extreme fatigue',5478.0000,6582)
,('Corticosteroids','NSAIDs','Clouded, blurred or dim vision',2458.0000,365)
,('Zafirlukast','Leukotriene modifiers','Shortness of breath,Chest tightness or pain',5245.0000,2546)
;

/*GROUP10.Medicine.PatientMedicine*/

INSERT INTO GROUP10.Medicine.PatientMedicine (PatientID,MedicineID) VALUES 
(2,22)
,(3,17)
,(4,17)
,(5,23)
,(6,21)
,(7,6)
,(8,2)
,(9,7)
,(10,8)
,(11,24)
,(12,9)
,(13,16)
,(14,18)
,(15,10)
,(16,10)
,(17,9)
,(18,7)
,(19,8)
,(20,13)
,(21,1)
,(22,3)
,(23,4)
,(24,1)
,(25,1)
,(26,3)
,(27,11)
,(28,11)
,(29,13)
,(30,13)
;

/*GROUP10.Patient.PatientRegistration */

INSERT INTO GROUP10.Patient.PatientRegistration (DoctorID,PatientID,[Date]) VALUES 
(80,2,'2020-06-25 08:56:49.293')
,(95,3,'2020-06-25 08:56:49.293')
,(88,4,'2020-06-25 08:56:49.293')
,(89,5,'2020-06-30 09:45:49.257')
,(79,6,'2020-06-30 09:45:49.257')
,(82,7,'2020-07-14 12:00:05.767')
,(84,8,'2020-07-14 12:00:05.767')
,(77,9,'2020-07-20 09:00:06.757')
,(77,10,'2020-07-20 09:00:06.757')
,(87,11,'2020-07-20 09:00:06.757')
,(77,12,'2020-07-24 10:00:06.757')
,(83,13,'2020-07-24 10:00:06.757')
,(95,14,'2020-07-24 10:00:06.757')
,(77,15,'2020-07-29 04:00:08.757')
,(77,16,'2020-07-29 04:00:08.757')
,(77,17,'2020-07-29 04:00:08.757')
,(77,18,'2020-07-29 04:00:08.757')
,(77,19,'2020-08-05 02:35:08.757')
,(79,20,'2020-08-05 02:35:08.757')
,(86,21,'2020-08-05 11:40:08.757') 
,(79,22,'2020-08-05 11:40:08.757')
,(79,23,'2020-08-05 11:40:08.757')
,(86,24,'2020-08-05 11:40:08.757')
,(86,25,'2020-08-05 11:40:08.757')
,(79,26,'2020-08-09 05:25:08.757')
,(76,27,'2020-08-09 05:25:08.757')
,(79,29,'2020-08-09 05:25:08.757')
,(79,30,'2020-08-09 05:25:08.757')
;


/*GROUP10.Patient.WardRooms*/

INSERT INTO [Patient].[WardRooms]
           ([PatientID]
           ,[Floor]
           ,[Type])
VALUES
(3 ,2  ,'Deluxe') ,
(4 , 2 ,'Special Room')  ,
(8 , 2 ,'General') ,
(9 , 2 ,'General') ,
(10, 2 ,'Semi Private')  ,
(11, 2 ,'General')  ,
(14, 3 ,'Special Room')  ,
(15, 3 ,'General')  ,
(16, 3 ,'Special Room')  ,
(17, 3 ,'General')  ,
(18, 3 , 'Deluxe')   ,
(20, 3 , 'Special Room' ) ,
(21, 4 , 'General') ,
(22, 4 , 'General') ,
(29, 4 , 'Semi Private')
;


/* GROUP10.Test.TestDetails */

INSERT INTO GROUP10.Test.TestDetails (TestID,TestName,TestDescription) VALUES 
(1001,'COVID-Test','Detects the presence of virus')
,(1002,'Puncture/Scratch Test','Checks for immediate allergic reactions')
,(1003,'Spirometry','Breathing test for Asthma')
,(1004,'Challenge Tests','If symptoms of asthma still persist')
,(1005,'A1C Test','determines if you are diabetic')
,(1006,'X-Ray','diagnoses broken bones,joints etc')
,(1007,'Urinalysis','urine infection/kidney problem')
,(1008,'Blood Test','major test')
,(1009,'MRI Scan','for nervous system usually')
,(1010,' Sonography/Ultrasound test','pcos/pcod related')
;

/*GROUP10.Patient.PatientTest */

INSERT INTO GROUP10.Patient.PatientTest (PatientID,TestID,StaffID,TestResultDescription,PatientTestDate) VALUES 
(4,1001,111,'Positive','2019-11-20 10:40:00.000')
,(9,1001,111,'Positive','2020-05-05 11:30:09.000')
,(10,1001,111,'Negative','2020-05-07 11:30:09.000')
,(15,1003,112,'Normal breathing rate','2020-07-22 11:30:09.000')
,(16,1003,112,'Normal breathing rate','2020-07-23 11:30:09.000')
,(17,1003,113,'Adverse breadthing rate by 10 units','2020-07-23 11:30:09.000')
,(27,1006,111,'Hair Line fracture','2020-07-30 11:40:09.000')
,(28,1006,111,'Tibia,fibula fracture','2020-08-25 11:40:09.000')
,(29,1006,113,'Joints swollen','2020-08-26 11:40:09.000')
,(30,1006,113,'uric acid crystal buildup at joints','2020-08-27 11:40:09.000')
;

/*GROUP10.BloodBank.AcceptenceRecord*/

INSERT INTO GROUP10.BloodBank.AcceptenceRecord (AcceptanceRecordID,PatientID,BloodBankID,AcceptanceDate,AcceptancePlace,AcceptedBloodGroup,AcceptedBloodAmount) VALUES 
(1,19,10,'2020-07-24 12:00:09.000','HospitalGroup10','A+',20.0000)
,(2,20,10,'2020-07-24 12:00:09.000','HospitalGrooup10','A+',10.0000)
,(3,21,10,'2020-07-25 12:00:09.000','HospitalGrooup10','A+',20.0000)
,(4,22,10,'2020-07-25 15:00:09.000','HospitalGrooup10','O+',30.0000)
,(5,23,10,'2020-07-26 11:00:09.000','HospitalGrooup10','AB+',330.0000)
,(6,24,10,'2020-07-27 11:00:09.000','HospitalGrooup10','O+',300.0000)
,(7,25,10,'2020-07-28 11:00:09.000','Chitra Nagar','O+',100.0000)
,(8,26,10,'2020-07-29 11:00:09.000','Chaitra Nagar','O+',20.0000)
,(9,27,10,'2020-07-30 11:00:09.000','Chaitra Nagar','O-',40.0000)
,(10,28,10,'2020-08-25 11:00:09.000','HospitalGrooup10','AB+',50.0000)
;
INSERT INTO GROUP10.BloodBank.AcceptenceRecord (AcceptanceRecordID,PatientID,BloodBankID,AcceptanceDate,AcceptancePlace,AcceptedBloodGroup,AcceptedBloodAmount) VALUES 
(11,29,10,'2020-08-26 11:00:09.000','HospitalGrooup10','AB+',60.0000)
,(12,19,10,'2020-08-27 11:00:09.000','HospitalGrooup10','A+',100.0000)
,(13,19,10,'2020-08-28 11:00:09.000','HospitalGrooup10','A+',200.0000)
,(14,22,10,'2020-08-29 11:00:09.000','HospitalGrooup10','O+',100.0000)
,(15,23,10,'2020-08-30 11:00:09.000','HospitalGrooup10','AB+',100.0000)
,(16,19,10,'2020-09-01 11:00:09.000','HospitalGrooup10','A+',100.0000)
;
/*GROUP10.BloodBank.BloodBank*/

INSERT INTO GROUP10.BloodBank.BloodBank (BloodBankID,BloodBankName,State,City,Zipcode) VALUES 
(1,'Borivali Blood Bank','Maharashtra','Mumbai','400012')
,(2,'Pallavi Blood Bank','Maharashtra','Mumbai','400010')
,(3,'Samarpan Blood Bank','Maharashtra','Mumbai','400011')
,(4,'Sant Nirankari Blood Bank','Gujrat','Surat','200045')
,(5,'AIIMS','Delhi','Delhi','110011')
,(6,' Fortis','Delhi','Delhi','110011')
,(7,'Medanta','Maharashtra','Mumbai','400014')
,(8,'Manak Blood Bank','Maharashtra','Mumbai','400013')
,(9,'Ashirwad Blood Bank','Maharashtra','Pune','430012')
,(10,'HospitalGroup10','Maharashtra','Mumbai','400012')
;

/*GROUP10.BloodBank.BloodDonationRecord */

INSERT INTO GROUP10.BloodBank.BloodDonationRecord (DonationRecordID,BloodBankID,DonorName,DonorState,DonorCity,DonorZIPcode,DonationDate,DonationBloodGroup,[BloodAmount(in ml)]) VALUES 
(1,10,'Akansha','Maharashtra','Mumbai','400001','2020-05-13 14:00:09.000','A+',350.0000)
,(2,10,'Aaliya','Maharashtra','Mumbai','400001','2020-05-13 11:00:09.000','A+',450.0000)
,(3,10,'Astha','Maharashtra','Thane','400005','2020-05-13 17:00:09.000','O+',470.0000)
,(4,10,'Anjali','Maharashtra','Thane','400005','2020-07-30 10:45:09.000','AB+',470.0000)
,(5,10,'Virendra','Maharashtra','Thane','400005','2020-07-02 11:00:09.000','AB-',470.0000)
,(6,10,'Meena','Maharashtra','Thane','400005','2020-05-13 11:00:09.000','AB+',350.0000)
,(7,10,'Deepika','Maharashtra','Pune','411000','2020-07-30 02:45:09.000','A+',350.0000)
,(8,10,'Deepak','Goa','Panji','403001','2020-07-30 11:45:09.000','O+',470.0000)
,(9,10,'Deepali','Goa','Panji','403001','2020-07-02 15:00:09.000','O+',350.0000)
,(10,10,'Meenakshi','Bihar','Patna','845401','2020-07-02 11:00:09.000','AB+',470.0000)
;
INSERT INTO GROUP10.BloodBank.BloodDonationRecord (DonationRecordID,BloodBankID,DonorName,DonorState,DonorCity,DonorZIPcode,DonationDate,DonationBloodGroup,[BloodAmount(in ml)]) VALUES 
(11,10,'Nikita','Bihar','Patna','845401','2020-05-13 13:00:09.000','O+',350.0000)
,(12,10,'Prashant','Karnataka','Banglore','990018','2020-07-30 11:45:09.000','O-',470.0000)
,(13,10,'Sushil','Maharashtra','Pune','411000','2020-07-02 12:00:09.000','A+',470.0000)
,(14,10,'Narendra','Maharashtra','Pune','411000','2020-05-13 11:00:09.000','AB-',470.0000)
;

/*GROUP10.BloodBank.BloodStock */

INSERT INTO GROUP10.BloodBank.BloodStock (StockID,BloodBankID,BloodGroup,Status,Quantity,BestBefore) VALUES 
(1,10,'A+','Available',350.0000,'2020-06-13 14:00:09.000')
,(2,10,'A+','Available',450.0000,'2020-06-13 11:00:09.000')
,(3,10,'O+','Available',470.0000,'2020-06-13 17:00:09.000')
,(4,10,'AB+','Available',470.0000,'2020-08-30 10:45:09.000')
,(5,10,'AB-','Available',470.0000,'2020-08-02 11:00:09.000')
,(6,10,'AB+','Available',350.0000,'2020-06-13 11:00:09.000')
,(7,10,'A+','Available',350.0000,'2020-08-30 02:45:09.000')
,(8,10,'O+','Available',470.0000,'2020-08-30 11:45:09.000')
,(9,10,'O+','Available',350.0000,'2020-08-02 15:00:09.000')
,(10,10,'AB+','Available',470.0000,'2020-08-02 11:00:09.000')
;
INSERT INTO GROUP10.BloodBank.BloodStock (StockID,BloodBankID,BloodGroup,Status,Quantity,BestBefore) VALUES 
(11,10,'O+','Available',350.0000,'2020-06-13 13:00:09.000')
,(12,10,'O-','Available',470.0000,'2020-08-30 11:45:09.000')
,(13,10,'A+','Available',470.0000,'2020-08-02 12:00:09.000')
,(14,10,'AB-','Available',470.0000,'2020-06-13 11:00:09.000')
;


