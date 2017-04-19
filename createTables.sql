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
Origin varchar2(10),
Destination varchar2(10),
Primary key (EventID),
CONSTRAINT loadEv_Origin_is_entity_fk Foreign key(Origin) references Entity(EntityID),
CONSTRAINT loadEv_Dest_is_entity_fk Foreign key(Destination) references Entity(EntityID),
CONSTRAINT loadEv_proNum_fk Foreign key (ProNumber) references Shipment(ProNumber)
);

create table Terminal(
TerminalID varchar2(10) not null,
AddressID number not null,
Primary key(TerminalID),
CONSTRAINT terminal_is_entity Foreign key(TerminalID) references Entity(EntityID)
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
CONSTRAINT custInter_proNum_fk Foreign key(ProNumber) references Shipment(ProNumber),
CONSTRAINT custInter_shipper_custID_fk Foreign key(Shipper) references Customer(ID),
CONSTRAINT custInter_consignee_custID_fk Foreign key(Consignee) references Customer(ID),
CONSTRAINT custInter_custPaying_custID_fk Foreign key(isPaying) references Customer(ID)
);

create table Door(
TerminalID varchar2(10) not null,
DoorNumber number(4) not null,
Occupied varchar2(10),
Primary key(DoorNumber,TerminalID),
CONSTRAINT door_termID_fk Foreign key(TerminalID) references Terminal(TerminalID),
CONSTRAINT door_occupied_entity_fk Foreign key(Occupied) references Entity(EntityID)
);

create table LineHaulTravel(
TrailerNumber varchar2(10) not null,
Origin varchar2(10) not null,
"Date" date not null,
Destination varchar2(10) not null,
Primary key(TrailerNumber, Origin, "Date"),
CONSTRAINT LineHaul_trailerNum_fk Foreign key(TrailerNumber) references Entity(EntityID),
CONSTRAINT LineHaul_origin_entity_fk Foreign key(Origin) references Terminal(TerminalID),
CONSTRAINT LineHaul_destination_entity_fk Foreign key(Destination) references Terminal(TerminalID)
);

create table CityHaulRoute(
TrailerNumber varchar(10) not null,
Route varchar2(10),
Primary key(Trailernumber),
CONSTRAINT cityHaul_trailerNum_entity_fk Foreign key(Trailernumber) references Entity(EntityID),
CONSTRAINT cityHaul_route_entity_fk Foreign key(Route) references Entity(EntityID)
);

create table EmployeeWorkPlace(
EmpID number(7) not null,
TerminalID varchar2(10) not null,
Primary key(EmpID),
CONSTRAINT empWrkPlc_empID_employee_fk Foreign key(EmpID) references Employee(EmpID),
CONSTRAINT empWrkPlc_termID_terminal_fk Foreign key(TerminalID) references Terminal(TerminalID)
);

create table ShipmentTravels(
ProNumber NUMBER(8) not null,
Origin VARCHAR2(10),
Destination VARCHAR2(10),
CurrentLocation VARCHAR2(10),
Primary key(ProNumber),
CONSTRAINT shpmtTrvl_proNum_shpmt_fk Foreign key(ProNumber) references Shipment(ProNumber),
CONSTRAINT shpmtTrvl_origin_entity_fk Foreign key(Origin) references Entity(EntityID),
CONSTRAINT shpmtTrvl_dest_entity_fk Foreign key(Destination) references Entity(EntityID),
CONSTRAINT shpmtTrvl_current_entity_fk Foreign key(CurrentLocation) references Entity(EntityID)
);

create table shipmentLoose(
ProNumber NUMBER(8) NOT NULL,
Cube number(4),
Quantity number(4),
Primary key(ProNumber),
CONSTRAINT shpmtLoos_proNum_shpmt_fk Foreign key(ProNumber) references Shipment(ProNumber)
);

--terminal trailers are trailers that are stored in the yard
create table TerminalTrailers(
TerminalID varchar2(10),
TrailerNumber varchar2(10),
Primary key(TerminalID, TrailerNumber),
CONSTRAINT termTrlr_termID_term_fk Foreign key(TerminalID) references Terminal(TerminalID),
CONSTRAINT termTrlr_trlrNum_entity_fk Foreign key(TrailerNumber) references Entity(EntityID)--oops forgot to change this to entity need to remake this table.
);

create table ShipmentPallets(
PalletID number(8) not null,
ProNumber number(8) NOT NULL,
Weight number(8),
Cube number(4),
Primary key(PalletID),
CONSTRAINT shpmtPlts_proNum_shpmt_fk Foreign key(ProNumber) references Shipment(ProNumber)
);

create table TerminalFloors(
TerminalID varchar2(10),
FloorID varchar2(10),
Primary key(TerminalID,FloorID),
CONSTRAINT termFlrs_termID_term_fk Foreign key(TerminalID) references Terminal(TerminalID),
CONSTRAINT termFlrs_flrID_entity_fk Foreign key(FloorID) references Entity(EntityID)
);

create table EventEmployees(
EventID NUMBER(10) NOT NULL,
EmpID NUMBER(7) NOT NULL,
Primary key(EventID,EmpID),
CONSTRAINT evntEmp_evntID_loadEv_fk foreign key(EventID) references LoadEvent(EventID),
CONSTRAINT evntEMp_empID_emp_fk foreign key(EmpID) references Employee(EmpID)
);