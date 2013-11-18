Feature: Sort events by event name and date

	As a user of CalCentral
	so that I can better find events
	I want to be able sort the events by name, and date

	Background: events have been added to database


	Scenario: Sort events by name
     Given that there are events 
     When I click the "Event Name"
     Then the events should be in alphabet order

    Scenario: Sort events by data
     Given that there are events 
     When I click the "Date & time"
     Then the events should be in order by oldest to newest

   Scenario: No events to sort
     Given that there are no events 
     When I click the "Events"
     Then there should be 0 events to sort

       