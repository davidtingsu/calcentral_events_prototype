Feature: Autocomplete when searching for events by club
     As a student search for club events
     I want be see suggestions for clubs
     So that I can search for club events faster

    Background:
        Given there are upcoming events
        When I go to the events homepage

    @javascript
    Scenario: Search one clubs
        When I search for club 1
        And I press the selection for club 1
        Then I club 1 should be selected
        Then I should should see events for club 1

    @javascript
    Scenario: Search one clubs
        When I search for club 1
        And I press the selection for club 1
        When I search for club 2
        And I press the selection for club 2
        When I search for club 3
        And I press the selection for club 3
        Then I club 1, 2, and 4 should be selected
        Then I should should see events for clubs 1, 2, and 4

    @javascript
    Scenario: club not found
        When I search for a non-existent club
        Then I should see "no matches found"


