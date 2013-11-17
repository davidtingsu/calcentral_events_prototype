Feature: Search events by club name
    As a student
    So that I can find out more information about clubs
    I want to be able to filter upcoming events that belong to those clubs


Background:
    Given there are upcoming events
    When I go to the events homepage

Scenario: press search without filling in input
    When I press "Search"
    Then I should see all events

Scenario: search multiple clubs for events
    When I fill in "club" with clubs "1, 5"
    And I press "Search"
    Then I should see events for clubs "1, 5"

Scenario: club not found
    When I fill in "club" with "i-do-not-exist"
    And I press "Search"
    Then I should see no events

Scenario: fill with whitespace and press search
    When I fill in "club" with clubs "   "
    And I press "Search"
    Then I should see all events


