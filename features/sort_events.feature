Feature: display list of movies sorted by different criteria
 
  As an CalCentral user
  So that I can quickly browse events based on my preferences
  I want to see events sorted by name or date

Background: events have been added to database
  
  Given the following events exist:
  | Name                    | Start                     | End                     |
  | Event_1                 | 2013-11-21 23:23:18 UTC   | 2013-11-22 00:23:18 UTC |
  | Event_2                 | 2013-11-22 23:23:18 UTC   | 2013-11-22 00:23:18 UTC |
  | Event_3                 | 2013-11-23 23:23:18 UTC   | 2013-11-22 00:23:18 UTC |
  | Event_4                 | 2013-11-24 23:23:18 UTC   | 2013-11-22 00:23:18 UTC |
  | Event_5                 | 2013-11-25 23:23:18 UTC   | 2013-11-22 00:23:18 UTC |
  | Event_6                 | 2013-11-26 23:23:18 UTC   | 2013-11-22 00:23:18 UTC |
  | Event_7                 | 2013-11-27 23:23:18 UTC   | 2013-11-22 00:23:18 UTC |
  | Event_8                 | 2013-11-28 23:23:18 UTC   | 2013-11-22 00:23:18 UTC |
  | Event_9                 | 2013-11-29 23:23:18 UTC   | 2013-11-22 00:23:18 UTC |

  And I am on the RottenPotatoes home page

Scenario: sort events alphabetically
  When I follow "Name"
    Then I should be on the search page
    And I should see "Event_1"
    And I should see "Event_2"
    And I should see "Event_3"
    And I should see "Event_4"
    And I should see "Event_5"
    And I should see "Event_6"
    And I should see "Event_7"
    And I should see "Event_8"
    And I should see "Event_9"


Scenario: sort movies in increasing order of release date
  When I follow "Start"
  Then I should be on the search page
    And I should see "2013-11-21 23:23:18 UTC"
    And I should see "2013-11-22 23:23:18 UTC"
    And I should see "2013-11-23 23:23:18 UTC"
    And I should see "2013-11-24 23:23:18 UTC"
    And I should see "2013-11-25 23:23:18 UTC"
    And I should see "2013-11-26 23:23:18 UTC"
    And I should see "2013-11-27 23:23:18 UTC"
    And I should see "2013-11-28 23:23:18 UTC"
    And I should see "2013-11-29 23:23:18 UTC"


