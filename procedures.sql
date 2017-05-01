/*--------------------Procedures--------------------------------*/

/*This procedure should be used every time a new shipment is created so that
you also insert the shipment into the shipment travels so that your able to track the shipment*/
execute newShipment(12345677, '05/31/17', 1000, 4000, 'RIC', 'ATL', 7421851, 7422383, 7422383);

select * from shipment;
select * from shipmenttravels;
describe loadevent;
describe eventemployees;
delete from shipment where proNumber = 12345677;
alter table shipment modify dueDate varchar(2);
delete from customerinteractions where pronumber = 12345677;
delete from shipmenttravels where pronumber = 12345677;

create or replace procedure newShipment(
p_ProNumber in Shipment.ProNumber%TYPE,
p_Duedate in varchar2,
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
insert into CustomerInteractions values(p_ProNumber, p_shipper, p_consignee, p_isPaying);
insert into ShipmentCondition values(p_ProNumber, 0,0,0);
End;
/
-----------------------------done
/*This is used to insert a new customer properly*/
create or replace procedure newCustomer(
p_name in Customer.Name%TYPE,
p_custID in Customer.ID%TYPE,
p_StreetAddress in Address.StreetAddress%TYPE,
p_ZipCode in Address.ZipCode%TYPE,
p_City in Address.City%TYPE,
p_State in Address.State%TYPE)
IS
adrID number(5) := AddressID_seq.nextval;
Begin
insert into address values(adrID,p_StreetAddress,p_ZipCode, p_City,p_State);
insert into Customer values(p_custID,p_name,adrID);
End;
/

----------------------------------------------------Done
describe employees;
/*This is used to insert a new Terminal properly */
create or replace procedure newTerminal(
p_Terminal in Terminal.TerminalID%TYPE,
p_StreetAddress in Address.StreetAddress%TYPE,
p_ZipCode in Address.ZipCode%TYPE,
p_City in Address.City%TYPE,
p_State in Address.State%TYPE)
IS
adrID number(5) := AddressID_seq.nextval;
Begin
insert into address values(adrID,p_StreetAddress,p_ZipCode, p_City,p_State);
insert into Entity values(p_terminal,'Terminal');
insert into Terminal values(p_Terminal,adrID);
End;
/

/*This is used to insert a new Employee properly */
create or replace procedure newEmployee(
p_EmpID in Employee.EmpID%TYPE,
p_FirstName in Employee.First_Name%TYPE,
p_LastName in Employee.Last_Name%TYPE,
p_wage in Employee.Wage%TYPE,
p_terminalID in Entity.EntityID%TYPE)
IS
Begin
insert into Employee(empID, first_name, last_name, wage) values(p_EmpID,p_FirstName,p_LastName,p_wage);
insert into EmployeeWorkPlace values(p_EmpID,p_terminalID);
End;
/

/* New Load Event Procedure*/
create or replace procedure newLoadEvent(
p_proNumber in Shipment.proNumber%TYPE,
p_destination in Entity.EntityID%TYPE,
p_employeeID in Employee.EmpID%TYPE)
IS
eventID number(5):= EventID_seq.nextval;
Begin
insert into LoadEvent values(eventID, SYSDATE, p_proNumber, (select currentLocation from shipmentTravels where p_proNumber=pronumber), p_destination);
insert into EventEmployees values(eventID,p_employeeID);
End;
/

/* New Trailer Route  works for both linehaul and city haul*/
create or replace procedure TrailerRoute(
p_TrailerNumber in Entity.EntityID%TYPE,
p_destination in Entity.EntityID%TYPE,
p_origin in Entity.EntityID%TYPE
)
IS
tpe varchar2(10);
Begin
select entity_type into tpe from Entity where EntityID=p_destination;
IF tpe = 'Route' 
THEN
insert into CityHaulRoute values(p_TrailerNumber,p_destination);
ELSE
insert into LineHaulTravel values(p_trailerNumber, p_origin, SYSDATE, p_destination);
END IF;
End;
/
