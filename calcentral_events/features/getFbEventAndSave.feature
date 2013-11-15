Feature: Getting facebook events for an url

   As a club administrator of a club on Calcentral
   So that I can get facebook events published on Calcentral
   I want to be able to use urls to get facebook events on Calcentral


   Scenario: pull Facebook events successfully to Calcentral
     Given I want facebook events for facebook page "The Berkeley Project"
     When I get facebook events for facebook page "https://facebook.com/berkeleyproject"
     Then there should be 8 events for Facebook page "313228564146"

   Scenario: club with no facebook id
     Given I want facebook events for facebook page ""
     When I get facebook events for facebook page ""
     Then there should be 0 events for Facebook page ""



   
