Feature: getting today's events from UCBerkeley events website

	 As a club administrator on CalCentral
	 So that I can get UCBerkeley events published on CalCentral
	 I want to be able to use urls to get UCBerkeley events on CalCentral

	 
    Scenario: pull UCBerkeley events successfully to CalCentral
        Given I want UCBerkeley events for the website "UCBerkeleyEvents"
	When I get UCBerkeley events from the website "http://events.berkeley.edu/index.php/rss/sn/pubaff/type/day/tab/all_events.html" for "UCBerkeleyEvents"
	Then there should be "Wildlife Rescue" for the event page "http://events.berkeley.edu/index.php/rss/sn/pubaff/type/day/tab/all_events.html"
	
    Scenario: website with wrong url
        Given I want UCBerkeley events for the website ""
	When I get UCBerkeley events from the website "" for ""
	Then there should be "" for the event page "" 
	