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