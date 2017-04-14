/*------------------TABLE CREATION----------------*/
create table Employee(
EmpID number (7) not null,
First_Name varchar2(25),
Last_Name varchar2(25),
Wage number (7),
primary key (EmpID));

create table Shipment(
ProNumber number(8) not null,
DueDate date,
TotalWeight number(8),
Price number(8),
Primary key (ProNumber));

create table ShipmentCondition(
ProNumber number not null,
Damaged number(4),
Short number(4),
over number(4),
Primary key(ProNumber));

create table Entity(
EntityID varchar2(10) not null,
Type varchar2(25),
Primary key(EntityID));

create table Address(
AddressID number(10) not null,
StreetAddress varchar(40),
City varchar(20),
ZipCode number(5),
State varchar(15),
Primary key(AddressID));

create table LoadEvent(
EventID number (10) not null,
"Date" DATE,
ProNumber number,
Origin varchar2,
Destination varchar2,
Primary key (EventID),
Foreign key (ProNumber) references Shipment(ProNumber)
Foreign key(Origin) references Entity(EntityID),
Foreign key(Destination) references Entity(EntityID));

create table Terminal(
TerminalID varchar2 not null,
AddressID number not null,
Primary key(TerminalID),
Foreign key(TerminalID) references Entity(EntityID),
Foreign key(AddressID) references Address(AddressID));

create table Customer(
ID number(7) not null,
AddressID number not null,
Name varchar2(25),
Primary key(ID),
Foreign key (AddressID) references Address(AddressID));

create table CustomerInteractions(
ProNumber not null,
Shipper number,
Consignee number,
isPaying number not null,
Primary key(ProNumber),
Foreign key(ProNumber) references Shipment(ProNumber),
Foreign key(Shipper) references Customer(ID),
Foreign key(Consignee) references Customer(ID)
Foreign key(isPaying) references Customer(ID));

create table Door(
TerminalID varchar2 not null,
DoorNumber number(4) not null,
Occupied varchar2,
Primary key(DoorNumber,TerminalID),
Foreign key(TerminalID) references Terminal(TerminalID),
Foreign key(Occupied) references Entity(EntityID));

create table Trailer(
TrailerNumber varchar2 not null,
DoorNumber number not null,
TerminalID varchar2,
Primary key (TrailerNumber),
Foreign key (TrailerNumber) references Entity(EntityID),
Foreign key (DoorNumber,TerminalID) references Door(DoorNumber,TerminalID));

create table LineHaulTravel(
TrailerNumber varchar2 not null,
Origin varchar2 not null,
"Date" date not null,
Destination varchar2,
Primary key(TrailerNumber, Origin, "Date"),
Foreign key(TrailerNumber) references Trailer(TrailerNumber),
Foreign key(Origin) references Terminal(TerminalID),
Foreign key(Destination) references Terminal(TerminalID));

create table CityHaulRoute(
TrailerNumber varchar2 not null,
Route varchar2,
Primary key(Trailernumber),
Foreign key(Trailernumber) references Trailer(TrailerNumber),
Foreign key(Route) references Entity(EntityID));

create table EmployeeWorkPlace(
EmpID number not null,
TerminalID varchar2,
Primary key(EmpID),
Foreign key(EmpID) references Employee(EmpID),
Foreign key(TerminalID) references Terminal(TerminalID));

create table FloorContents(
ProNumber NUMBER not null,
FloorID varchar,
TerminalID varchar2,
Primary key(ProNumber),
Foreign key(ProNumber) references Shipment(ProNumber),
Foreign key(FloorID) references Entity(EntityID),
Foreign key(TerminalID) references Terminal(TerminalID));

create table ShipmentTravels(
ProNumber number not null,
Origin varchar2,
Destination varchar2,
CurrentLocation varchar2,
Primary key(ProNumber),
Foreign key(ProNumber) references Shipment(ProNumber),
Foreign key(Origin) references Terminal(TerminalID),
Foreign key(Destination) references Terminal(TerminalID),
Foreign key(CurrentLocation) references Terminal(TerminalID)
);

create table shipmentLoose(
ProNumber number,
Cube number(4),
Quantity number(4),
Primary key(ProNumber),
Foreign key(ProNumber) references Shipment(ProNumber));

create table TerminalTrailers(
TerminalID varchar2,
TrailerNumber varchar2,
Primary key(TerminalID, TrailerNumber),
Foreign key(TerminalID) references Terminal(TerminalID),
Foreign key(TrailerNumber) references Trailer(TrailerNumber));

create table ShipmentPallets(
PalletID number(8) not null,
ProNumber number,
Weight number(8),
Cube number(4),
Primary key(PalletID),
Foreign key(ProNumber) references Shipment(ProNumber));

create table TerminalFloors(
TerminalID varchar2,
FloorID varchar2,
Primary key(TerminalID,FloorID),
Foreign key(TerminalID) references Terminal(TerminalID),
Foreign key(FloorID) references Entity(EntityID));

create table EventEmployees(
EventID number,
Employee number,
Primary key(EventID,Employee),
foreign key(EventID) references LoadEvent(EventID),
foreign key(Employee) references Employee(EmpID));

/*--------------------Views-------------------------------------*/

/* create a view that shows the Terminal and its full address*/
create view TerminalAddresses(Terminal_id,StreetAddress,City,ZipCode,state)
as
select terminalID,StreetAddress,City,ZipCode,State
from terminal join Address on terminals.AddressID=Address.AddressID;


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

/*-------------------Functions-----------------------------------*/


/*-------------------Procedures----------------------------------*/

/*Create a procedure to insert a new terminal that inserts the address of the new terminal followed by inserting the terminal with the created address ID*/

/*Create a procedure to insert a new Customer that inserts the address of the new Customer followed by inserting the Customer with the created address ID*/

/*Create a procedure to insert a new LoadEvent that takes in employeeID, and the two locations of the event. It creates the LoadEvent first, and uses the created eventID to insert the employee into the Event Employees table */


/*-------------------Triggers------------------------------------*/

/*Create a Trigger that  after an employee works 11 load events in a day than he gets a 1% raise*/


/*--------------------DATABASE POPULATION------------------------*/

insert into employee(014364,'Taylor','Nelson',17.85);
insert into employee(018580,'John','Smith',17.85);
insert into employee(014987,'Jermel','Simmons',14.00);
insert into employee(019230,'Mike','Thompson',17.85);
insert into employee(014855,'Allan','Jones',14.00);

insert into entity('742FA','Floor');
insert into entity('742FB','Floor');
insert into entity('742FC','Floor');
insert into entity('742FD','Floor');
insert into entity('742FE','Floor');
insert into entity('742FF','Floor');
insert into entity('742FG','Floor');
insert into entity('742FH','Floor');
insert into entity('742FI','Floor');
insert into entity('742FJ','Floor');
insert into entity('742FK','Floor');
insert into entity('742FL','Floor');
insert into entity('742FM','Floor');
insert into entity('742FN','Floor');
insert into entity('742FP','Floor');
insert into entity('742FQ','Floor');
insert into entity('742FR','Floor');
insert into entity('742FS','Floor');
insert into entity('742FT','Floor');
insert into entity('742FU','Floor');
insert into entity('742FV','Floor');
insert into entity('742FW','Floor');
insert into entity('742FX','Floor');
insert into entity('742F1','Floor');
insert into entity('742F2','Floor');
insert into entity('742F3','Floor');
insert into entity('742F4','Floor');
insert into entity('742F5','Floor');
insert into entity('742F6','Floor');
insert into entity('742F7','Floor');
insert into entity('742F8','Floor');
insert into entity('742F9','Floor');
insert into entity('5888','Trailer');
insert into entity('148015','Trailer');
insert into entity('148006','Trailer');
insert into entity('843','Trailer');
insert into entity('846','Trailer');
insert into entity('852','Trailer');
insert into entity('5029','Trailer');
insert into entity('3058','Trailer');
insert into entity('RIC','Terminal');
insert into entity('RKE','Terminal');
insert into entity('CLT','Terminal');
insert into entity('ATL','Terminal');
insert into entity('NFK','Terminal');
insert into entity('DNTN','Route');
insert into entity('ZXTN','Route');
insert into entity('PETE','Route');
insert into entity('APPT','Route');

insert into shipment(65613541,3/18/17,83, 74.53);
insert into shipment(39247393,3/18/17,302, 110.53);
insert into shipment(97413454,NULL,2583, 587.34);
insert into shipment(95503108,NULL,633, 245.09);
insert into shipment(48172764,3/18/17,947, 388.92);
insert into shipment(95503090,NULL,1035, 400.17);

insert into shipmentConditions(65613541,0,0,0);
insert into shipmentConditions(39247393,0,0,0);
insert into shipmentConditions(97413454,2,0,0);
insert into shipmentConditions(95503108,0,1,0);
insert into shipmentConditions(48172764,0,0,0);
insert into shipmentConditions(95503090,0,0,1);

insert into address(AddressID_seq.nextval,'1831 Boulevard W', 23230, Richmond, VA);
insert into address(AddressID_seq.nextval,'115 E Cary st', 23219, Richmond, VA);
insert into address(AddressID_seq.nextval,'1900 Meadowville Technlogy Pkwy', 23836, Richmond, VA);
insert into address(AddressID_seq.nextval,'1600 Continental Blvd', 23834, South Chesterfield, VA);
insert into address(AddressID_seq.nextval,'UNKNOWN', 23150, Sandston, VA);
insert into address(AddressID_seq.nextval,'2601 Swineford Rd', 23237, North Chesterfield, VA);
insert into address(AddressID_seq.nextval,'1712 Plantation Rd', 24012, Roanoke, VA);
insert into address(AddressID_seq.nextval,'7500 Statesville Rd', 28269, Charlotte, NC);
insert into address(AddressID_seq.nextval,'6125 Duquesne Dr SW', 30336, Atlanta, GA);
insert into address(AddressID_seq.nextval,'1005 Enterprise Cir', 23321, Chesapeake, VA);

insert into LoadEvent(EventID_seq.nextval, 3/17/17,65613541);
insert into LoadEvent(EventID_seq.nextval, 3/17/17,39247393);
insert into LoadEvent(EventID_seq.nextval, 3/17/17,97413454);
insert into LoadEvent(EventID_seq.nextval, 3/17/17,95503108);
insert into LoadEvent(EventID_seq.nextval, 3/17/17,48172764);
insert into LoadEvent(EventID_seq.nextval, 3/17/17,95503090);

/*****TODO GRAB ADDRESS IDs FROM ADDRESS TABLE*/
insert into Terminal('RIC','ADDRESS ID HERE');
insert into Terminal('RKE','ADDRESS ID HERE');
insert into Terminal('CLT','ADDRESS ID HERE');
insert into Terminal('ATL','ADDRESS ID HERE');
insert into Terminal('NFK','ADDRESS ID HERE');

/*****TODO GRAB ADDRESS IDs FROM ADDRESS TABLE*/
insert into Customer(7421851,'Elegant Draperies', 'ADDRESS ID HERE');
insert into Customer(7422846,'Foley Company', 'ADDRESS ID HERE');
insert into Customer(7421978,'Medline Industries', 'ADDRESS ID HERE');
insert into Customer(7422383,'Sun Chemical Corporation', 'ADDRESS ID HERE');
insert into Customer(7429683,'Henry Schein Animal Health', 'ADDRESS ID HERE');

insert into CustomerInteractions(65613541,7421851,7421851);
insert into CustomerInteractions(39247393,7422846,7422846);
insert into CustomerInteractions(97413454,7421978,7421978);
insert into CustomerInteractions(95503108,7421978,7421978);
insert into CustomerInteractions(48172764,7422383,4817264);
insert into CustomerInteractions(95503090,7429683,7429683);

insert into Door('RIC',1,NULL);
insert into Door('RIC',2,480135);
insert into Door('RIC',3,NULL);
insert into Door('RIC',4,NULL);
insert into Door('RIC',5,NULL);
insert into Door('RIC',6,NULL);
insert into Door('RIC',7,NULL);
insert into Door('RIC',8,NULL);
insert into Door('RIC',9,NULL);
insert into Door('RIC',10,NULL);
insert into Door('RIC',11,NULL);
insert into Door('RIC',12,148056);
insert into Door('RIC',13,NULL);
insert into Door('RIC',14,NULL);
insert into Door('RIC',15,5029);
insert into Door('RIC',16,NULL);
insert into Door('RIC',17,NULL);
insert into Door('RIC',18,NULL);
insert into Door('RIC',19,NULL);
insert into Door('RIC',20,NULL);
insert into Door('RIC',21,148126);
insert into Door('RIC',22,NULL);
insert into Door('RIC',23,NULL);
insert into Door('RIC',24,NULL);
insert into Door('RIC',25,NULL);
insert into Door('RIC',26,148006);
insert into Door('RIC',27,NULL);
insert into Door('RIC',28,NULL);
insert into Door('RIC',29,NULL);
insert into Door('RIC',30,3058);
insert into Door('RIC',31,NULL);
insert into Door('RIC',32,NULL);
insert into Door('RIC',33,NULL);
insert into Door('RIC',34,148015);
insert into Door('RIC',35,5888);
insert into Door('RIC',36,NULL);
insert into Door('RIC',37,NULL);
insert into Door('RIC',38,NULL);
insert into Door('RIC',39,NULL);
insert into Door('RIC',40,NULL);
insert into Door('RIC',41,NULL);
insert into Door('RIC',42,NULL);
insert into Door('RIC',43,NULL);
insert into Door('RIC',44,NULL);
insert into Door('RIC',45,NULL);
insert into Door('RIC',46,NULL);
insert into Door('RIC',47,NULL);
insert into Door('RIC',48,NULL);
insert into Door('RIC',49,NULL);
insert into Door('RIC',50,NULL);
insert into Door('RIC',51,NULL);

insert into Trailer(148006,26,'RIC');
insert into Trailer(5029,15,'RIC');
insert into Trailer(148126,21,'RIC');
insert into Trailer(148056,12,'RIC');
insert into Trailer(5888,35,'RIC');
insert into Trailer(480135,2,'RIC');
insert into Trailer(148015,34,'RIC');
insert into Trailer(3058,30,'RIC');
insert into Trailer(843,18,'RIC');

insert into LineHaulTravel(3058,'CLT',03/17/17,'RIC');
insert into LineHaulTravel(148126,'RIC',03/17/17,'RKE');
insert into LineHaulTravel(5029,'RIC',03/17/17,'FRD');
insert into LineHaulTravel(5888,'RIC',03/17/17,'ATL');
insert into LineHaulTravel(3058,'RIC',03/17/17,'CLT');

insert into CityHaulRoute('843','DNTN');
insert into CityHaulRoute('480135','ZXTN');
insert into CityHaulRoute('148015','PETE');
insert into CityHaulRoute('148056','APPT');

insert into EmployeeWorkPlace(014364,'RIC');
insert into EmployeeWorkPlace(018580,'RIC');
insert into EmployeeWorkPlace(014987,'RIC');
insert into EmployeeWorkPlace(019230,'RIC');
insert into EmployeeWorkPlace(014855,'RIC');

insert into FloorContents(95503108,'U','RIC');
insert into FloorContents(97413454,'U','RIC');

insert into ShipmentTravels(65613541,'CLT','RIC','RIC');
insert into ShipmentTravels(39247393,'CLT','RIC','RIC');
insert into ShipmentTravels(95503108,'CLT','RIC','RIC');
insert into ShipmentTravels(97413454,'CLT','RIC','RIC');

insert into shipmentLoose(6561341,0,0);
insert into shipmentLoose(39247393,0,0);
insert into shipmentLoose(97413454,0,0);
insert into shipmentLoose(95503066,0,0);
insert into shipmentLoose(48172764,0,0);
insert into shipmentLoose(95503090,0,0);

insert into TerminalTrailers('RIC','843');
insert into TerminalTrailers('RIC','846');
insert into TerminalTrailers('RIC','852');
insert into TerminalTrailers('RIC','148006');
insert into TerminalTrailers('RIC','5888');
insert into TerminalTrailers('RIC','5029');
insert into TerminalTrailers('RIC','148015');

insert into shipmentsPallets(PalletID_seq.nextval,65613541,83,1);
insert into shipmentsPallets(PalletID_seq.nextval,97413454,369,1);
insert into shipmentsPallets(PalletID_seq.nextval,97413454,1002,1);
insert into shipmentsPallets(PalletID_seq.nextval,97413454,369,1);
insert into shipmentsPallets(PalletID_seq.nextval,97413454,458,1);
insert into shipmentsPallets(PalletID_seq.nextval,97413454,205,1);
insert into shipmentsPallets(PalletID_seq.nextval,97413454,369,1);
insert into shipmentsPallets(PalletID_seq.nextval,97413454,136,1);
insert into shipmentsPallets(PalletID_seq.nextval,48172764,402,1);
insert into shipmentsPallets(PalletID_seq.nextval,48172764,545,1);

insert into TerminalFloors('RIC','A');
insert into TerminalFloors('RIC','B');
insert into TerminalFloors('RIC','C');
insert into TerminalFloors('RIC','D');
insert into TerminalFloors('RIC','E');
insert into TerminalFloors('RIC','F');
insert into TerminalFloors('RIC','G');
insert into TerminalFloors('RIC','H');
insert into TerminalFloors('RIC','I');
insert into TerminalFloors('RIC','J');
insert into TerminalFloors('RIC','K');
insert into TerminalFloors('RIC','L');
insert into TerminalFloors('RIC','M');
insert into TerminalFloors('RIC','N');
insert into TerminalFloors('RIC','P');
insert into TerminalFloors('RIC','Q');
insert into TerminalFloors('RIC','R');
insert into TerminalFloors('RIC','S');
insert into TerminalFloors('RIC','T');
insert into TerminalFloors('RIC','U');
insert into TerminalFloors('RIC','V');
insert into TerminalFloors('RIC','W');
insert into TerminalFloors('RIC','X');
insert into TerminalFloors('RIC','1');
insert into TerminalFloors('RIC','2');
insert into TerminalFloors('RIC','3');
insert into TerminalFloors('RIC','4');
insert into TerminalFloors('RIC','5');
insert into TerminalFloors('RIC','6');
insert into TerminalFloors('RIC','7');
insert into TerminalFloors('RIC','8');
insert into TerminalFloors('RIC','9');

/*TODO Grab EVENT IDs HERE */
insert into EventEmployees(EVENTID GOES HERE, 014364);
insert into EventEmployees(EVENTID GOES HERE, 018580);
insert into EventEmployees(EVENTID GOES HERE, 014987);
insert into EventEmployees(EVENTID GOES HERE, 019230);
insert into EventEmployees(EVENTID GOES HERE, 014855);
insert into EventEmployees(EVENTID GOES HERE, 014364);
