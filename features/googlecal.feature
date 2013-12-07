Feature: Export event to google calendar
	As a user of Calcentral,
	So that I have my event saved in my google calendar,
	I want to be able to export event to google calendar.

Background:
    Given there are upcoming events

Scenario: Export a valid event to google calendar
    When I go to the events homepage
    When I press "Search"
    Then I should see a clickable and directed link in Event_1 
   
Scenario: Attempt to Export an invalid event to google calendar
    When I go to the events homepage
    When I press "Search"
    Then I should not see a link for a non-existent event




    
    