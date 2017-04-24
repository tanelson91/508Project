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

/*View for showing shipments and how many pallets and loose it has */
create view Shipment_VU(ProNumber, DueDate, TotalWeight,price, Num_Pallets, Num_Loose)
as
select proNumber, DueDate, TotalWeight, price, Count(pallets), quantity
from shipment natural join shipmentPallets, natural join shipmentLoose
group by proNumber;


/*View for that shows all information of a particular shipment */
create view Shipment2_VU(ProNumber, DueDate, TotalWeight, price, originTerm, DestinationTerm, CurrentTerm Shipper, Consignee)
as
select proNumber, DueDate, TotalWeight,price, origin, destination, currentlocation, shipper, consignee, ispaying
from shipment natural join ShipmentTravels natural join CustomerInteractions;


/*View that shows after a loadEvent is created */
create view LoadEvent_VU(ProNumber, "Date" , Employee, origin, CurrentLocation, EventID)
as
select proNumber, "Date", EmpID, origin, Destination, EventID
from LoadEvent natural join EventEmployees;
