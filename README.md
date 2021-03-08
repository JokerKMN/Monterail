## Background
We want to develop a ticket-selling platform. We are hoping to get popular pretty
quickly, so prepare for high traffic!
While completing the test task please try to put yourself in the mind of the user as
much as possible. It's very important to think of all the possible edge cases you can.
The frontend part of the application is not yet ready, so feel free to design the API
however you want.
### High-level features
* Get info about an event
* Get info about about available tickets
* Reserve ticket
* Pay for ticket
* Get info about reservation
### Feature requirements
#### Get info about an event
* Event has a name
* Event has a date and a time
* Event can have multiple type of tickets
#### Get info about available tickets
* We should be able toreceive information about which tickets
* are still available for sale and in which quantity.
#### Reserve ticket
* Each ticket has a selling option defined:
* even - we can only buy tickets in quantity that is even
* all together - we can only buy all the tickets at once
* avoid one - we can only buy tickets in a quantity that will not leave only 1 ticket
avaiable
* Reservation is valid for 15 minutes, after that it is realesed.
#### Pay for ticket
* For the sake of simplicity we operate only on the EUR currency. Feel free to use
* the provided adapter.
#### Get info about reservation
* Return information about the state of the reservation and its data.
