Given  /I want UCBerkeley events for the website "([^"]*)"/ do |club_name| end

When(/^I get UCBerkeley events from the website "(.*?)" for "(.*?)"$/) do |url,club_name|
     
     doc = Event.makeXmlDoc(url)
     next if doc.blank?
     table = Event.parsingHtmlAndReturnDateTimes
     all_events = Event.savingEventsBerkeley(doc, table)
     
     club = (Club.find_by_name(club_name) or Club.create!(name: club_name))    
     
     all_events.each do |event|
         new_event = Event.create!(:name => event.name, :start_time => event.start_time, :end_time => event.end_time, :description => event.description, :facebook_id => event.facebook_id)
	 club.events << new_event and club.save!
     end
end

Then /there should be "(.*)" for the event page "(.*)"/ do |title, url|
     doc = Event.makeXmlDoc(url)    
     if doc.blank?
         next
     end
     table = Event.parsingHtmlAndReturnDateTimes
     events = Event.savingEventsBerkeley(doc, table)
    
     events.each do |e|
         if e['name'] == title
	     assert e['name'] == title, "doesn't match"
         end
     end
end