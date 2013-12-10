Then /^I should see a clickable and directed link/ do
   id   =  Event.last.id
   link = publishtogoogle_event_path(id)
   links = page.all('.portfolio-item a').map{|a| a['href']}
   links = links.join
   links.should include(link)
end

Then /^I should not see a link for a non-existent event/ do
   non_existent_id = Event.find(:all, :select => "id").map(&:id).max  + 1 
   links = page.all("a").map{|a| a['href']}
   links.should_not include(publishtogoogle_event_path(non_existent_id))
 end
