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

/*Bonus trigger: if employees do more than 40 events in a day give them a bonus*/