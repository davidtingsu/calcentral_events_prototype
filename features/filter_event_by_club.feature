Feature: Search events by club name
    As a student
    So that I can find out more information about clubs
    I want to be able to filter upcoming events that belong to those clubs


Background:
    Given there are upcoming events
    When I go to the events homepage

Scenario: press search without filling in input
    When I press the button search
    Then I should see all events

Scenario: search multiple clubs for events
    When I press the button search for club
    When I fill in "Search" with clubs "1, 5"
    When I press the button search for club
    Then I should see events for clubs "1, 5"

Scenario: club not found
    When I fill in "Search" with "i-do-not-exist"
    When I press the button search for club
    When I press the button search
    Then I should see no events
    Then I should see "Sorry! No Events found"

Scenario: fill with whitespace and press search
    When I fill in "Search" with clubs "   "
    When I press the button search
    Then I should see all events


