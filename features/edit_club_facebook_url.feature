Feature: Add Facebook Url to diplay events in CalCentral
	As a club administrator of a club on Calcentral,
	So that I can get my facebook events published on Calcentral,
	I want to be able to submit a url edit through the Calcentral system

Background:
    Given there are upcoming events
    When I go to the events homepage

Scenario: Search for my club
    When I press the button search for club
    When I fill in "Search" with "Club_1"
    When I check "Search by Club"
    When I press the button search
    And I should see "Event_1"
    And I should see "Club_1"

Scenario: Edit Facebook URl
	When I go to the club 1 homepage
	When I fill in the facebook url with "https://www.facebook.com/groups/Club_2/events/"
	And I press "Save"
	Then I should see the alert "Club_1 successfully updated!"

Scenario: Edit Invalid Facebook URl
	When I go to the club 3 homepage
	And I press the save button
	Then I should see the alert "Club_3 not updated!"
	