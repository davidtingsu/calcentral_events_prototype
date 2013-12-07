Feature: Retrieve events from Callink

    As a compute programmer who wants to automate the process of retrieving callink group
    So that I get callink event data from a callink group
    I want to parse the callink events rss feed and store the events into the database

    Background:
    Given I am a computer
    And clubs from todays rss feed exist
    And there are no events

Scenario: Get events for a callink rss feed
    When I parse callink events from todays rss feed
    Then there should be 14 events


Scenario: Callink feed does not exist
    When I get a 404 when parsing callink events with message "Not Found"
    Then there should be 0 events
