Given /^there are upcoming events$/ do 
    5.times{
        club = FactoryGirl.create(:club_with_categories)
        3.times{
            FactoryGirl.create(:event_with_club, club: club)
        }
    }
end

When /^(?:|I )fill in "([^"]*)" with categories "([^"]*)"$/ do |field, value|
  category_ids = value.scan(/\d+/)
  category_names = category_ids.map{|id| Category.find(id)}.map(&:name).compact
  fill_in(field, :with => category_names.join(','))
end

Then /^(?:|I )should see all events$/ do
    page.should have_selector('.table-striped tbody tr')
    event_rows = all('.table-striped tbody tr')
    event_rows.count.should be(Event.count)
end

Then /^I should see events for categories "(.*)"$/ do |category_ids|
  category_ids = category_ids.scan(/\d+/)
  category_names = category_ids.map{|id| Category.find(id)}.map(&:name).compact
  page.should have_selector('.table-striped tbody tr')
  event_rows = all('.table-striped tbody tr')
  event_rows.count.should be(Event.find_by_category(*category_names).count)
end

