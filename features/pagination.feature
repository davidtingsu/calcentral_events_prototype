Feature: Using pagination to display 10 event per page
 
  As an CalCentral user
  So that I can see my events with a better view
  I want to see 10 events per page

Background: Events have been created
    Given there are upcoming events
    When I go to the events homepage

Scenario: no categories or clubs are chosen all events should be visible
    When I press the button search
    Then I should see all events
    And I should see "Next"
    And I should see "Last"
    When I follow "Next"
    Then I should see "Prev"
    Then I should see "First"
    When I follow "First"
    And I should see "Next"
    And I should see "Last"

Scenario: Events for a club with less than 10 events, no pagination
    When I go to the events homepage
    Then I should see "Search"
    When I fill in "Search" with "Club_1"
    When I press the button search
    And I should not see "Next"
    And I should not see "Last"





    

    
