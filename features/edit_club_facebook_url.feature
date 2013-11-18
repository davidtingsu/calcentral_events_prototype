Feature: Add Facebook Url to diplay events in CalCentral
	As a club administrator of a club on Calcentral,
	So that I can get my facebook events published on Calcentral,
	I want to be able to submit a url edit through the Calcentral system

Background:
    Given there are upcoming events

Scenario: Search for my club
    When I go to the clubs homepage
    Then I should see "Search"
    When I fill in "club" with "Club_2"
    And I press "Search"
    Then I should see "Details about Club_2"
    And I should see "Description"

Scenario: Edit Facebook URl
	When I go to the club homepage
	When I follow "Edit"
	Then I should see "Submit Event to CalCentral"
	When I fill in "Facebook URL" with "https://www.facebook.com/groups/Club_2/events/"
	And I press "Submit Events"
	Then I should see "events were successfully added!!!"
	And the facebook url for Club_2 should be "https://www.facebook.com/groups/Club_2/events/"

Scenario: Edit Invalid Facebook URl
	When I go to the club homepage
	When I follow "Edit"
	Then I should see "Submit Event to CalCentral"
	When I fill in "Facebook URL" with "https://www.facebook.com/groups/invalid"
	And I press "Submit Events"
	Then I should see "Invalid URL"
	