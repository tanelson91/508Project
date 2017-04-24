/*--------------------Procedures--------------------------------*/

/*This procedure should be used every time a new shipment is created so that
you also insert the shipment into the shipment travels so that your able to track the shipment*/
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
insert into shipment values(p_ProNumber,TO_DATE(p_Duedate,'MM/DD/YY'),p_TotalWeight, p_Price);
insert into shipmentTravels values(p_ProNumber,p_origin,p_destination,p_origin);
insert into CustomerInteractions values(p_ProNumber,p_shipper,p_consignee,p_isPaying);
End;

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
