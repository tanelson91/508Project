CREATE TABLE Employee(
EmpID number (7) not null,
First_Name varchar2(25),
Last_Name varchar2(25),
Wage float
CONSTRAINT emp_wage_ck CHECK (Wage >= 14.00),
primary key (EmpID)
);

create table Shipment(
ProNumber number(8) not null,
DueDate date,
TotalWeight number(8),
Price number(6,2)
CONSTRAINT shpmt_price_ck CHECK (Price >= 50),
Primary key (ProNumber)
);

create table ShipmentCondition(
ProNumber number(8) not null,
Damaged number(4),
Short number(4),
over number(4),
Primary key(ProNumber),
CONSTRAINT shpmt_cnd_pronum_fk FOREIGN KEY (ProNumber) REFERENCES shipment (ProNumber)
);

create table Entity(
EntityID varchar2(10) not null,
Entity_type varchar2(25),
Primary key(EntityID)
);

create table Address(
AddressID number(10) not null,
StreetAddress varchar(40),
City varchar(20),
ZipCode number(5) not null,
State varchar(2),
Primary key (AddressID)
);

create table LoadEvent(
EventID number (10) not null,
"Date" DATE not null,
ProNumber number (8),
Origin varchar2,
Destination varchar2,
Primary key (EventID),
Foreign key(Origin) references Entity(EntityID),
Foreign key(Destination) references Entity(EntityID)
CONSTRAINT loadEv_proNum_fk Foreign key (ProNumber) references Shipment(ProNumber)
);

create table Terminal(
TerminalID varchar2(10) not null,
AddressID number not null,
Primary key(TerminalID),
Foreign key(TerminalID) references Entity(EntityID)
);

create table Customer(
ID number(7) not null,
Name varchar2(25) not null,
AddressID number(10) not null,
Primary key(ID),
CONSTRAINT cust_addrID_fk FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

create table CustomerInteractions(
ProNumber not null,
Shipper number,
Consignee number,
isPaying number not null,
Primary key(ProNumber),
Foreign key(ProNumber) references Shipment(ProNumber),
Foreign key(Shipper) references Customer(ID),
Foreign key(Consignee) references Customer(ID),
Foreign key(isPaying) references Customer(ID)
);

create table Door(
TerminalID varchar2(10) not null,
DoorNumber number(4) not null,
Occupied varchar2(1),
Primary key(DoorNumber,TerminalID),
Foreign key(TerminalID) references Terminal(TerminalID)
Foreign key(Occupied) references Entity(EntityID)
);

create table LineHaulTravel(
TrailerNumber varchar2(10) not null,
Origin varchar2(10) not null,
"Date" date not null,
Destination varchar2(10) not null,
Primary key(TrailerNumber, Origin, "Date"),
Foreign key(TrailerNumber) references Entity(EntityID),
Foreign key(Origin) references Terminal(TerminalID),
Foreign key(Destination) references Terminal(TerminalID)
);

create table CityHaulRoute(
TrailerNumber varchar(10) not null,
Route varchar2(10),
Primary key(Trailernumber),
Foreign key(Trailernumber) references Entity(EntityID),
Foreign key(Route) references Entity(EntityID)
);

create table EmployeeWorkPlace(
EmpID number(7) not null,
TerminalID varchar2(10) not null,
Primary key(EmpID),
Foreign key(EmpID) references Employee(EmpID),
Foreign key(TerminalID) references Terminal(TerminalID)
);

create table FloorContents(--
ProNumber NUMBER(8) not null,
FloorID VARCHAR2(10),
TerminalID VARCHAR2(10),
Primary key(ProNumber),
Foreign key(ProNumber) references Shipment(ProNumber),
Foreign key(FloorID) references Entity(EntityID),
Foreign key(TerminalID) references Terminal(TerminalID)
);

create table ShipmentTravels(
ProNumber NUMBER(8) not null,
Origin VARCHAR2(10),
Destination VARCHAR2(10),
CurrentLocation VARCHAR2(10),
Primary key(ProNumber),
Foreign key(ProNumber) references Shipment(ProNumber),
Foreign key(Origin) references Entity(EntityID),
Foreign key(Destination) references Entity(EntityID),
Foreign key(CurrentLocation) references Entity(EntityID)
);

create table shipmentLoose(
ProNumber NUMBER(8) NOT NULL,
Cube number(4),
Quantity number(4),
Primary key(ProNumber),
Foreign key(ProNumber) references Shipment(ProNumber)
);

--terminal trailers are trailers that are stored in the yard
create table TerminalTrailers(
TerminalID varchar2(10),
TrailerNumber varchar2(10),
Primary key(TerminalID, TrailerNumber),
Foreign key(TerminalID) references Terminal(TerminalID),
Foreign key(TrailerNumber) references Entity(EntityID)--oops forgot to change this to entity need to remake this table.
);

create table ShipmentPallets(
PalletID number(8) not null,
ProNumber number(8) NOT NULL,
Weight number(8),
Cube number(4),
Primary key(PalletID),
Foreign key(ProNumber) references Shipment(ProNumber)
);

create table TerminalFloors(
TerminalID varchar2(10),
FloorID varchar2(10),
Primary key(TerminalID,FloorID),
Foreign key(TerminalID) references Terminal(TerminalID),
Foreign key(FloorID) references Entity(EntityID)
);

create table EventEmployees(
EventID NUMBER(10) NOT NULL,
EmpID NUMBER(7) NOT NULL,
Primary key(EventID,EmpID),
foreign key(EventID) references LoadEvent(EventID),
foreign key(EmpID) references Employee(EmpID)
);

/*--------------------Queries-----------------------------------*/
/*You can use this query to see all the shipments contained in an entity, whether it be a trailer, floor or terminal*/
select s.Pronumber
from ShipmentTravels s join entity e
on s.currentLocation=e.EntityID
where e.EntityID='$trailer_number';

/*--------------------Procedures--------------------------------*/

/*This procedure should be used every time a new shipment is created so that
you also insert the shipment into the shipment travels so that your able to track the shipment*/
create or replace procedure newShipment(
p_ProNumber in Shipment.ProNumber%TYPE,
p_Duedate in Shipment.date%TYPE,
p_TotalWeight in Shipment.TotalWeight%TYPE,
p_Price in Shipment.Price%TYPE,
p_origin in ShipmentTravels.origin%TYPE,
p_destination in ShipmentTravels.destination%TYPE,
p_shipper in Customer.ID%TYPE,
p_consignee in Customer.ID%TYPE,
p_isPaying in Customer.ID%TYPE)
IS
Begin
insert into shipment values(p_ProNumber,p_Duedate,p_TotalWeight, p_Price);
insert into shipmentTravels values(p_ProNumber,p_origin,p_destination,p_origin);
insert into CustomerInteraction values(p_ProNumber,p_shipper,p_consignee,p_isPaying);
End;
)

/*This is used to insert a new customer properly*/
create or replace procedure newCustomer(
p_name in Customer.Name%TYPE,
p_StreetAddress in Address.StreetAddress%TYPE,
p_ZipCode in Address.ZipCode%TYPE,
p_City in Address.City%TYPE,
p_State in Address.State%TYPE)
IS
adrID;--
Begin
adrID := AddressID_seq.nextval;--
insert into address values(adrID,p_StreetAddress,p_ZipCode, p_City,p_State);
insert into Customer values(p_name,adrID);--need to use above addressID!!!
End;

/*This is used to insert a new Terminal properly */
create or replace procedure newTerminal(
p_Terminal in Terminal.TerminalID%TYPE,
p_StreetAddress in Address.StreetAddress%TYPE,
p_ZipCode in Address.ZipCode%TYPE,
p_City in Address.City%TYPE,
p_State in Address.State%TYPE)
IS
adrID;--
Begin
adrID := AddressID_seq.nextval;--
insert into address values(adrID,p_StreetAddress,p_ZipCode, p_City,p_State);
insert into Entity values(p_terminal,'Terminal');
insert into Terminal values(p_Terminal,adrID);--need to use above addressID!!!
End;

/*This is used to insert a new Employee properly */
create or replace procedure newEmployee(
p_EmpID in Employee.EmpID%TYPE,
p_FirstName in Employee.FirstName%TYPE,
p_LastName in Employee.LastName%TYPE,
p_wage in Employee.Wage%TYPE,
p_terminalID in Entity.EntityID%TYPE)
IS
Begin
insert into Employee values(p_EmpID,p_FirstName,p_LastName,p_wage);
insert into EmployeeWorkPlace values(p_EmpID,p_terminalID);
End;

/*--------------------Views-------------------------------------*/
/* view that shows the Terminal and its full address*/
create view TerminalAddresses(terminalID,StreetAddress,City,ZipCode,state)
as
select terminalID,Address.StreetAddress,Address.City,Address.ZipCode,Address.State
from terminal join Address on terminal.AddressID=Address.AddressID;

/* view that shows the customer and their full address*/
create view CustomerAddresses(Terminal_id,StreetAddress,City,ZipCode,state)
as
select customerID,Address.StreetAddress,Address.City,Address.ZipCode,Address.State
from Customer join Address on customerID.AddressID=Address.AddressID;

/*--------------------Sequences----------------------------------*/

CREATE SEQUENCE AddressID_seq
START WITH 1
MAXVALUE
5000
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE EventID_seq
START WITH 1
MAXVALUE
5000
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE PalletID_seq
START WITH 1
MAXVALUE
5000
INCREMENT BY 1
NOCYCLE;

/*--------------------Triggers---------------------------------*/

/* After a new Event is created, we use the destination of the new event as the current location of 
the shipment.*/
create or replace trigger updateShipmentLocation
After insert EventID on LoadEvent
for each row
begin 
update table shipmentTravels
set currentLocation = (select destination from LoadEvent where eventID=new:eventID)
where proNumber=(select proNumber from LoadEvent where eventID=new:eventID)
end;

/*----------------------Ideas------------------------------------*/
--when inserting into employee, must also register employee work place----------
--After inserting an employee select that employee and display it
--when deleting an employee enter the employee ID and display then employee, followed by a button to delete that employee if it is the one you want to delete.

--when creating a shipment we also need to add to the CustomerInteraction table---

/*Upon successful insertion into the shipments table we need to take the user to a webpage that allows them to enter in the fields for inserting pallets, followed by a page that allows you to enter in fields for loose pieces*/
--when inserting a shipment we also need to add to the shipmentloose table
--when inserting a shipment we also need to add to the shipmentPallets table

/*Need a page for the trucker to enter in his origin, destination and trailer number*/
--whenever a linehaul leaves the terminal it must insert into the LineHaulTravel

/*An employee should be able to update shipment conditions at any time, maybe a page for this?*/
--need to be able to update shipmentConditions

--when inserting into terminal insert it into entity first---

--floor contents should be able to be replaced with a query along the lines of "show all the shipments whose current location is a given floor number???

--Shipment Travels procedure is already written, it updates the shipments current location.

/*after successful insertion into the loadEvent table take the user to a webpage that allows them to enter in the fields for inserting employees into EventEmployees, this works similarly as adding pallets to shipments*/
--when inserting into loadEvent we need to insert the employees worked on the event into EventEmployees

----------BONUS IDEAS------------

--If we wanted to get fancy we could write a procedure for inserting into LoadEvent where we automatically grab the "origin" from the shipments current location

/*--------------------DATABASE POPULATION------------------------*/
insert into employee values(014364,'Taylor','Nelson',17.85);
insert into employee values(018580,'John','Smith',17.85);
insert into employee values(014987,'Jermel','Simmons',14.00);
insert into employee values(019230,'Mike','Thompson',17.85);
insert into employee values(014855,'Allan','Jones',14.00);

insert into entity values('742FA','Floor');
insert into entity values('742FB','Floor');
insert into entity values('742FC','Floor');
insert into entity values('742FD','Floor');
insert into entity values('742FE','Floor');
insert into entity values('742FF','Floor');
insert into entity values('742FG','Floor');
insert into entity values('742FH','Floor');
insert into entity values('742FI','Floor');
insert into entity values('742FJ','Floor');
insert into entity values('742FK','Floor');
insert into entity values('742FL','Floor');
insert into entity values('742FM','Floor');
insert into entity values('742FN','Floor');
insert into entity values('742FP','Floor');
insert into entity values('742FQ','Floor');
insert into entity values('742FR','Floor');
insert into entity values('742FS','Floor');
insert into entity values('742FT','Floor');
insert into entity values('742FU','Floor');
insert into entity values('742FV','Floor');
insert into entity values('742FW','Floor');
insert into entity values('742FX','Floor');
insert into entity values('742F1','Floor');
insert into entity values('742F2','Floor');
insert into entity values('742F3','Floor');
insert into entity values('742F4','Floor');
insert into entity values('742F5','Floor');
insert into entity values('742F6','Floor');
insert into entity values('742F7','Floor');
insert into entity values('742F8','Floor');
insert into entity values('742F9','Floor');

insert into entity values('5888','Trailer');
insert into entity values('148015','Trailer');
insert into entity values('148006','Trailer');
insert into entity values('843','Trailer');
insert into entity values('846','Trailer');
insert into entity values('852','Trailer');
insert into entity values('5029','Trailer');
insert into entity values('3058','Trailer');
INSERT INTO entity VALUES(148126,'Trailer');
INSERT INTO entity VALUES(148056,'Trailer');
INSERT INTO entity VALUES(480135,'Trailer');

insert into entity values('RIC','Terminal');
insert into entity values('RKE','Terminal');
insert into entity values('CLT','Terminal');
insert into entity values('ATL','Terminal');
insert into entity values('NFK','Terminal');
insert into entity values('FRD','Terminal');

insert into entity values('DNTN','Route');
insert into entity values('ZXTN','Route');
insert into entity values('PETE','Route');
insert into entity values('APPT','Route');

insert into shipment values(65613541,'18-MAR-17',83, 74.53);
insert into shipment values(39247393,'18-MAR-17',302, 110.53);
insert into shipment values(97413454,NULL,2583, 587.34);
insert into shipment values(95503108,NULL,633, 245.09);
insert into shipment values(48172764,'18-MAR-17',947, 388.92);
insert into shipment values(95503090,NULL,1035, 400.17);

insert into shipmentCondition values(65613541,0,0,0);
insert into shipmentCondition values(39247393,0,0,0);
insert into shipmentCondition values(97413454,2,0,0);
insert into shipmentCondition values(95503108,0,1,0);
insert into shipmentCondition values(48172764,0,0,0);
insert into shipmentCondition values(95503090,0,0,1);

insert into address values(AddressID_seq.nextval,'1831 Boulevard W', 'Richmond', 23220, 'VA');
insert into address values(AddressID_seq.nextval,'115 E Cary st', 'Richmond', 23214, 'VA');
insert into address values(AddressID_seq.nextval,'1900 Meadowville Technlogy Pkwy', 'Richmond', 23836, 'VA');
insert into address values(AddressID_seq.nextval,'1600 Continental Blvd','South Chesterfield', 23834, 'VA');
insert into address values(AddressID_seq.nextval,'UNKNOWN', 'Sandston', 23150, 'VA');
insert into address values(AddressID_seq.nextval,'2601 Swineford Rd', 'North Chesterfield', 23237, 'VA');
insert into address values(AddressID_seq.nextval,'1712 Plantation Rd', 'Roanoke', 24012, 'VA');
insert into address values(AddressID_seq.nextval,'7500 Statesville Rd', 'Charlotte', 28269, 'NC');
insert into address values(AddressID_seq.nextval,'6125 Duquesne Dr SW', 'Atlanta', 30336, 'GA');
insert into address values(AddressID_seq.nextval,'1005 Enterprise Cir', 'Chesapeake', 23321, 'VA');
insert into address values(AddressID_seq.nextval,'18 Powell Lane', 'Fredericksburg', 22406, 'VA');

insert into LoadEvent values(EventID_seq.nextval, '17-MAR-17',65613541);
insert into LoadEvent values(EventID_seq.nextval, '17-MAR-17',39247393);
insert into LoadEvent values(EventID_seq.nextval, '17-MAR-17',97413454);
insert into LoadEvent values(EventID_seq.nextval, '17-MAR-17',95503108);
insert into LoadEvent values(EventID_seq.nextval, '17-MAR-17',48172764);
insert into LoadEvent values(EventID_seq.nextval, '17-MAR-17',95503090);

insert into Terminal values('RIC',6);
insert into Terminal values('RKE',7);
insert into Terminal values('CLT',8);
insert into Terminal values('ATL',9);
insert into Terminal values('NFK',10);
insert into Terminal values('FRD',11);

insert into Customer values(7421851,'Elegant Draperies', 1);
insert into Customer values(7422846,'Foley Company', 3);
insert into Customer values(7421978,'Medline Industries', 2);
insert into Customer values(7422383,'Sun Chemical Corporation', 4);
insert into Customer values(7429683,'Henry Schein Animal Health', 5);

insert into CustomerInteractions values(65613541,7421851,7421851,7421851);
insert into CustomerInteractions values(39247393,7422846,7422846,7422846);
insert into CustomerInteractions values(97413454,7421978,7421978,7421978);
insert into CustomerInteractions values(95503108,7421978,7421978,7421978);
insert into CustomerInteractions values(48172764,7422383,7421851,7421851);
insert into CustomerInteractions values(95503090,7429683,7429683,7429683);

insert into Door VALUES('RIC',1,NULL);
insert into Door VALUES('RIC',2,'480135');
insert into Door VALUES('RIC',3,NULL);
insert into Door VALUES('RIC',4,NULL);
insert into Door VALUES('RIC',5,NULL);
insert into Door VALUES('RIC',6,NULL);
insert into Door VALUES('RIC',7,NULL);
insert into Door VALUES('RIC',8,NULL);
insert into Door VALUES('RIC',9,NULL);
insert into Door VALUES('RIC',10,NULL);
insert into Door VALUES('RIC',11,NULL);
insert into Door VALUES('RIC',12,'148056');
insert into Door VALUES('RIC',13,NULL);
insert into Door VALUES('RIC',14,NULL);
insert into Door VALUES('RIC',15,'5029');
insert into Door VALUES('RIC',16,NULL);
insert into Door VALUES('RIC',17,NULL);
insert into Door VALUES('RIC',18,NULL);
insert into Door VALUES('RIC',19,NULL);
insert into Door VALUES('RIC',20,NULL);
insert into Door VALUES('RIC',21,'148126');
insert into Door VALUES('RIC',22,NULL);
insert into Door VALUES('RIC',23,NULL);
insert into Door VALUES('RIC',24,NULL);
insert into Door VALUES('RIC',25,NULL);
insert into Door VALUES('RIC',26,'148006');
insert into Door VALUES('RIC',27,NULL);
insert into Door VALUES('RIC',28,NULL);
insert into Door VALUES('RIC',29,NULL);
insert into Door VALUES('RIC',30,'3058');
insert into Door VALUES('RIC',31,NULL);
insert into Door VALUES('RIC',32,NULL);
insert into Door VALUES('RIC',33,NULL);
insert into Door VALUES('RIC',34,'148015');
insert into Door VALUES('RIC',35,'5888');
insert into Door VALUES('RIC',36,NULL);
insert into Door VALUES('RIC',37,NULL);
insert into Door VALUES('RIC',38,NULL);
insert into Door VALUES('RIC',39,NULL);
insert into Door VALUES('RIC',40,NULL);
insert into Door VALUES('RIC',41,NULL);
insert into Door VALUES('RIC',42,NULL);
insert into Door VALUES('RIC',43,NULL);
insert into Door VALUES('RIC',44,NULL);
insert into Door VALUES('RIC',45,NULL);
insert into Door VALUES('RIC',46,NULL);
insert into Door VALUES('RIC',47,NULL);
insert into Door VALUES('RIC',48,NULL);
insert into Door VALUES('RIC',49,NULL);
insert into Door VALUES('RIC',50,NULL);
insert into Door VALUES('RIC',51,NULL);

insert into LineHaulTravel VALUES(3058,'CLT','03-MAR-17','RIC');
insert into LineHaulTravel VALUES(148126,'RIC','03-MAR-17','RKE');
insert into LineHaulTravel VALUES(5029,'RIC','03-MAR-17','FRD');
insert into LineHaulTravel VALUES(5888,'RIC','03-MAR-17','ATL');
insert into LineHaulTravel VALUES(3058,'RIC','03-MAR-17','CLT');

insert into CityHaulRoute VALUES('843','DNTN');
insert into CityHaulRoute VALUES('480135','ZXTN');
insert into CityHaulRoute VALUES('148015','PETE');
insert into CityHaulRoute VALUES('148056','APPT');

insert into EmployeeWorkPlace VALUES(014364,'RIC');
insert into EmployeeWorkPlace VALUES(018580,'RIC');
insert into EmployeeWorkPlace VALUES(014987,'RIC');
insert into EmployeeWorkPlace VALUES(019230,'RIC');
insert into EmployeeWorkPlace VALUES(014855,'RIC');

insert into FloorContents VALUES(95503108,'742FU','RIC');
insert into FloorContents VALUES(97413454,'742FU','RIC');

insert into ShipmentTravels VALUES(65613541,'CLT','RIC','RIC');
insert into ShipmentTravels VALUES(39247393,'CLT','RIC','RIC');
insert into ShipmentTravels VALUES(95503108,'CLT','RIC','RIC');
insert into ShipmentTravels VALUES(97413454,'CLT','RIC','RIC');

insert into shipmentLoose VALUES(65613541,0,0);
insert into shipmentLoose VALUES(39247393,0,0);
insert into shipmentLoose VALUES(97413454,0,0);
insert into shipmentLoose VALUES(95503108,0,0);
insert into shipmentLoose VALUES(48172764,0,0);
insert into shipmentLoose VALUES(95503090,0,0);

insert into TerminalTrailers VALUES('RIC','843');
insert into TerminalTrailers VALUES('RIC','846');
insert into TerminalTrailers VALUES('RIC','852');

insert into shipmentPallets VALUES(PalletID_seq.nextval,65613541,83,1);
insert into shipmentPallets VALUES(PalletID_seq.nextval,97413454,369,1);
insert into shipmentPallets VALUES(PalletID_seq.nextval,97413454,1002,1);
insert into shipmentPallets VALUES(PalletID_seq.nextval,97413454,369,1);
insert into shipmentPallets VALUES(PalletID_seq.nextval,97413454,458,1);
insert into shipmentPallets VALUES(PalletID_seq.nextval,97413454,205,1);
insert into shipmentPallets VALUES(PalletID_seq.nextval,97413454,369,1);
insert into shipmentPallets VALUES(PalletID_seq.nextval,97413454,136,1);
insert into shipmentPallets VALUES(PalletID_seq.nextval,48172764,402,1);
insert into shipmentPallets VALUES(PalletID_seq.nextval,48172764,545,1);

insert into TerminalFloors VALUES('RIC','742FA');
insert into TerminalFloors VALUES('RIC','742FB');
insert into TerminalFloors VALUES('RIC','742FC');
insert into TerminalFloors VALUES('RIC','742FD');
insert into TerminalFloors VALUES('RIC','742FE');
insert into TerminalFloors VALUES('RIC','742FF');
insert into TerminalFloors VALUES('RIC','742FG');
insert into TerminalFloors VALUES('RIC','742FH');
insert into TerminalFloors VALUES('RIC','742FI');
insert into TerminalFloors VALUES('RIC','742FJ');
insert into TerminalFloors VALUES('RIC','742FK');
insert into TerminalFloors VALUES('RIC','742FL');
insert into TerminalFloors VALUES('RIC','742FM');
insert into TerminalFloors VALUES('RIC','742FN');
insert into TerminalFloors VALUES('RIC','742FP');
insert into TerminalFloors VALUES('RIC','742FQ');
insert into TerminalFloors VALUES('RIC','742FR');
insert into TerminalFloors VALUES('RIC','742FS');
insert into TerminalFloors VALUES('RIC','742FT');
insert into TerminalFloors VALUES('RIC','742FU');
insert into TerminalFloors VALUES('RIC','742FV');
insert into TerminalFloors VALUES('RIC','742FW');
insert into TerminalFloors VALUES('RIC','742FX');
insert into TerminalFloors VALUES('RIC','742F1');
insert into TerminalFloors VALUES('RIC','742F2');
insert into TerminalFloors VALUES('RIC','742F3');
insert into TerminalFloors VALUES('RIC','742F4');
insert into TerminalFloors VALUES('RIC','742F5');
insert into TerminalFloors VALUES('RIC','742F6');
insert into TerminalFloors VALUES('RIC','742F7');
insert into TerminalFloors VALUES('RIC','742F8');
insert into TerminalFloors VALUES('RIC','742F9');

insert into EventEmployees VALUES(1, 014364);
insert into EventEmployees VALUES(2, 018580);
insert into EventEmployees VALUES(3, 014987);
insert into EventEmployees VALUES(4, 019230);
insert into EventEmployees VALUES(5, 014855);
insert into EventEmployees VALUES(6, 014364);
