Feature: Retrieve events from Facebook Groups.

	As a compute programmer who wants to automate the process of retrieving Facebook Group Events
	So that I get facebook event data from a facebook group
	I want query the facebook api and store the events into the database

Scenario: Get events for a club that  has an associated Facebook Group
    Given I want facebook events for facebook group "Hackers at Berkeley"
    When I get facebook events for Facebook Group "276905079008757" with user access token "fbaccesstoken"
    Then there should be 110 events for facebook club 276905079008757


Scenario: Get events for a club that has an associated Facebook Group without access token and without event id
    Given I want facebook events for facebook group "Hackers at Berkeley"
    When I get facebook events for Facebook Group "276905079008757" with user access token " "
    Then there should be 0 events for facebook club 276905079008757