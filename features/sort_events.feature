Feature: display list of events sorted by different criteria
 
  As an CalCentral user
  So that I can quickly browse events based on my preferences
  I want to see events sorted by name 

@javascript
Scenario: sort events alphabetically
    Given there are upcoming events
    When I go to the events homepage
    When I press "Search"
    When I sort by name
    Then I should see all events sorted in ascending order
    When I sort by name
    Then I should see all events sorted in descending order
    
@javascript
Scenario: no events exist
    Given there are no events
    When I go to the events homepage
    When I press "Search"
    Then I should see no events


