Given  /I want UCBerkeley events for the website "([^"]*)"/ do |club_name| end

When(/^I get UCBerkeley events from the website "(.*?)" for "(.*?)"$/) do |url,club_name|
     all_events = Event.responseEventObject(url)
     #UCBerkeleyEventPage =  File.open( File.join(File.expand_path(File.dirname(__FILE__)), "..", "support", "UCBerkeleyEventPageFake.json"), "r").read
     #FakeWeb.register_uri(:get, url, :body => UCBerkeleyEventPage)
     club = (Club.find_by_name(club_name) or Club.create!(name: club_name))
     next if all_events.blank?
     
     all_events.each do |event|
         new_event = Event.create!(:name => event.name, :start_time => event.start_time, :end_time => event.end_time, :description => event.description, :facebook_id => event.facebook_id)
	 club.events << new_event and club.save!
     end
end

Then /there should be "(.*)" for the event page "(.*)"/ do |title, url|
     events = Event.responseEventObject(url)
     if events.blank?
         next
     end
     events.each do |e|
         #debugger
         if e['name'] == title
	     assert e['name'] == title, "doesn't match"
         end
     end
end