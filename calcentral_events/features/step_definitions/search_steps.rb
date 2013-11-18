Given /^there are upcoming events$/ do 
    5.times{
        club = FactoryGirl.create(:club_with_categories)
        3.times{
            FactoryGirl.create(:event_with_club, club: club)
        }
    }
end

When /^(?:|I )fill in "([^"]*)" with (.+) "([^"]*)"$/ do |field, model_type, value|
  ids = value.scan(/\d+/)
  case model_type
    when 'categories'
      category_names = ids.map{|id| Category.find_by_id(id)}.compact.map(&:name)
      fill_in(field, :with => category_names.join(','))
    when 'clubs'
      club_names = ids.map{|id| Club.find_by_id(id)}.compact.map(&:name)
      fill_in(field, :with => club_names.join(','))
  end

end

Then /^(?:|I )should see (.*) events$/ do |keyword|
    case keyword
        when 'all'
            page.should have_selector('.table-striped tbody tr')
            event_rows = all('.table-striped tbody tr')
            event_rows.count.should be(Event.count)

        when 'no'
            page.should_not have_selector('.table-striped tbody tr')
    end
end


Then /^I should see events for (.+) "(.*)"$/ do |model_type, ids|
  ids = ids.scan(/\d+/)
  event_rows = all('.table-striped tbody tr')

  case model_type
      when 'categories'
          category_names = ids.map{|id| Category.find_by_id(id)}.compact.map(&:name)
          page.should have_selector('.table-striped tbody tr') if Event.find_by_category(*category_names).any?
          event_rows.count.should be(Event.find_by_category(*category_names).count)
      when 'clubs'
          club_names = ids.map{|id| Club.find_by_id(id)}.compact.map(&:name)
          page.should have_selector('.table-striped tbody tr') if Event.find_by_club(*club_names).any?
          event_rows.count.should be(Event.find_by_club(*club_names).count)
      end
end

Then(/^the facebook url for Club_(\d+) should be "(.*?)"$/) do |arg1, arg2|
  assert page.body.include?(arg2)
end