Feature: Export events in ical and Google Calendar format


As a student that uses Google Calendar or any other calendar tool
So that I can stay in tune with my Club events,
I want to be able to add my events to my personal Calendar


Scenario: Add event to google cal
	When I click google cal
	Then I should see my event added to google cal

Scenario: Add event to iCal cal
	When I click ical cal 
	Then I should see my event added to apple cal

Scenario: Add event to iCal but nothing to open
	When I click iCal cal 
	Then I should see a error message	