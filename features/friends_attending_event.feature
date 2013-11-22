Feature: See Facebook Friends attending events


As a student that attending events 
So that I can know who is attending events
I want to be able to see which friends are attending events 

Scenario: See number of friends attending
	When I see event displayed 
	Then I should the number of facebook friends attending

Scenario: No friends attending
	When I see event displayed 
	Given there are no friends attending
	Then I should see zero friends attending