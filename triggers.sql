/*--------------------Triggers---------------------------------*/

/* After a new Event is created, we use the destination of the new event as the current location of 
the shipment.*/
create or replace trigger updateShipmentLocation
After insert on LoadEvent
for each row
begin 
update shipmentTravels
set currentLocation = (select destination from LoadEvent where eventID=:new.eventID)
where proNumber=(select proNumber from LoadEvent where eventID=:new.eventID);
end;

/* We need to delete the Employee from Employee Workplace if we delete the Employee */
create or replace trigger updateEmployeeWorkPlace
After delete on employee
for each row
begin 
delete from EmployeeWorkPlace where empID=:old.empID
end;

/*Bonus trigger: if employees do more than 40 events in a day give them a bonus*/
