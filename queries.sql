/*--------------------Queries-----------------------------------*/
/*You can use this query to see all the shipments contained in an entity, whether it be a trailer, floor or terminal*/
select s.Pronumber
from ShipmentTravels s join entity e
on s.currentLocation=e.EntityID
where e.EntityID='$trailer_number';

/*You can use this query to view all the pallets of a given shipment*/
select palletID, weight, cube
from ShipmentPallets sp
where sp.proNumber= '$proNumber';

/*You can use this query to view all the pallets of a given shipment*/
select cube, quantity
from ShipmentLoose sl
where sl.proNumber= '$proNumber';
