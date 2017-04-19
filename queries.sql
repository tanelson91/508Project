/*--------------------Queries-----------------------------------*/
/*You can use this query to see all the shipments contained in an entity, whether it be a trailer, floor or terminal*/
select s.Pronumber
from ShipmentTravels s join entity e
on s.currentLocation=e.EntityID
where e.EntityID='$trailer_number';