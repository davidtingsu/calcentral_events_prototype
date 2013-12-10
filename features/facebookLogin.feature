Feature: having a facebook login on Calcentral
	 
	 As a student
	 So that I can access all events on facebook while logged into CalCentral
	 I want to be able to additionally log into facebook through the CalCentral system

    Scenario: logged into facebook successfully
    	      Given I am on Cal Central Events home page 
	      Then I should see "Sign in with Facebook"
	      Given I am signed in with provider "facebook"
	      Then I should see "Bob"
	       
	      
	      
    Scenario: failed to log into facebook
              Given I am signed in with provider "facebook"
	      Then I should not see "Please re-enter your password"
