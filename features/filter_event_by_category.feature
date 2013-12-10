Feature: Filter events by category
    As a student
    So that I can find out about events that pique my interest
    I want to see search results by match my category


Background: Events have been created
    Given there are upcoming events
    When I go to the events homepage

Scenario: no categories are chosen all events should be visible
    When I check "Search by Category"
    Then I should see all events

Scenario: search events belonging to one ore more categories 
    When I fill in "Search" with categories "1, 2"
    When I press the button search
    Then I should see events for categories "1, 2"

Scenario: empty category value filled in 
    When I fill in "Search" with categories ""
    When I press the button search
    Then I should see all events

