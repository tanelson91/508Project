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
ProNumber not null,
Damaged number(4),
Short number(4),
over number(4),
Primary key(ProNumber));

create table Entity(
EntityID number(10) not null,
Type varchar2(25),
Primary key(EntityID));

create table Address(
AddressID number(10) not null,
StreetAddress varchar(40),
City varchar(20),
ZipCode number(5)
Primary key(AddressID));

create table LoadEvent(
EventID number (10) not null,
"Date" DATE,
ProNumber,
Primary key (EventID),
Foreign key (ProNumber) references Shipments(ProNumber));

create table Terminal(
TerminalID not null,
StreetAddress,
ZipCode,
City,
State,
Primary key(TerminalID),
Foreign key(TerminalID) references Entity(Ent),
Foreign key(StreetAddress) references Address(StreetAddress),
Foreign key(ZipCode) references Address(ZipCode),
Foreign key(City) references Address(City));

create table Customer(
ID number(7) not null,
Name varchar2(25),
StreetAddress,
ZipCode,
City,
State,
Primary key(ID),
Foreign key(StreetAddress) references Address(StreetAddress),
Foreign key(ZipCode) references Address(ZipCode),
Foreign key(City) references Address(City),
Foreign key(State) references Address(State));

create table CustomerInteractions(
ProNumber not null,
CustomerID,
Primary key(ProNumber),
Foreign key(ProNumber) references Shipment(ProNumber),
Foreign key(CustomerID) references Customer(CustomerID));

create table ShipmentCustomers(
ProNumber not null,
Shipper,
Consignee,
Primary key(ProNumber),
Foreign key(ProNumber) references Shipment(ProNumber),
Foreign key(Shipper) references Customer(CustomerID),
Foreign key(Consignee) references Customer(CustomerID));

create table Door(
TerminalID not null,
DoorNumber number(4) not null,
Occupied boolean,
Primary key(TerminalID),
Primary key(DoorNumber),
Foreign key(TerminalID) references Terminal(TerminalID));

create table Trailer(
TrailerNumber not null,
DoorNumber,
TerminalID,
Primary key (TrailerNumber),
Foreign key (TrailerNumber) references Entity(EntityID),
Foreign key (DoorNumber) references Door(DoorNumber),
Foreign key (TerminalID) references Terminal(TerminalID));

create table LineHaulTravel(
TrailerNumber not null,
Origin not null,
"Date" date not null,
Destination,
Primary key(TrailerNumber),
Primary key(Origin),
Primary key("Date"),
Foreign key(TrailerNumber) references Trailer(TrailerNumber),
Foreign key(Origin) references Terminal(TerminalID),
Foreign key(Destination) references Terminal(TerminalID));

create table CityHaulRoute(
TrailerNumber not null,
Route,
Primary key(Trailernumber),
Foreign key(Trailernumber) references Trailer(TrailerNumber),
Foreign key(Route) references Entity(EntityID));

create table EmployeeWorkPlace(
EmpID not null,
TerminalID,
Primary key(EmpID),
Foreign key(EmpID) references Employee(EmpID),
Foreign key(TerminalID) references Terminal(TerminalID));

create table FloorContents(
ProNumber not null,
FloorID,
TerminalID,
Primary key(ProNumber),
Foreign key(ProNumber) references Shipment(ProNumber),
Foreign key(FloorID) references Entity(EntityID),
Foreign key(TerminalID) references Terminal(TerminalID));

create table ShipmentTravels(
ProNumber not null,
Origin,
Destination,
CurrentLocation,
Primary key(ProNumber),
Foreign key(ProNumber) references Shipment(ProNumber)
);

create table EventLocations(
EventID,
Origin,
Destination,
Primary key(EventID),
Foreign key(EventID) references LoadEvent(EventID),
Foreign key(Origin) references Entity(EntityID),
Foreign key(Destination) references Entity(EntityID));

create table shipmentLoose(
ProNumber,
Cube number(4),
Quantity number(4),
Primary key(ProNumber),
Foreign key(ProNumber) references Shipment(ProNumber));

create table TerminalTrailers(
TerminalID,
TrailerNumber,
Primary key(TerminalID),
Primary key(TrailerNumber),
Foreign key(TerminalID) references Terminal(TerminalID),
Foreign key(TrailerID) references Trailer(TrailerID));

create table ShipmentPallets(
PalletID number(8) not null,
ProNumber,
Weight number(8),
Cube number(4),
Primary key(PalletID),
Foreign key(ProNumber) references Shipment(ProNumber));

create table TerminalFloors(
TerminalID,
FloorID,
Primary key(TerminalID),
Primary key(FloorID),
Foreign key(TerminalID) references Terminal(TerminalID),
Foreign key(FloorID) references Entity(EntityID));

create table EventEmployees(
EventID,
Employee,
Primary key(EventID),
Primary key(Employee),
foreign key(EventID) references LoadEvent(EventID),
foreign key(Employee) references Employee(EmpID));
