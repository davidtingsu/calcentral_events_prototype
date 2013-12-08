Then /^I should see a clickable and directed link in Event_(\d+)$/ do |id|
  event = Event.find_by_id(id)
  page.should have_link("#{event.name}", :href => publishtogoogle_event_path(id))
end

Then /^I should not see a link for a non-existent event/ do
   non_existent_id = Event.find(:all, :select => "id").map(&:id).max  + 1 
   links = page.all("a").map{|a| a['href']}
   links.should_not include(publishtogoogle_event_path(non_existent_id))
end