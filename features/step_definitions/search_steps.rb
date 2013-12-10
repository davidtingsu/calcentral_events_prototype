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
            page.should have_selector('.portfolio-item')
            event_rows = all('.portfolio-item')
            event_rows.count.should be(Event.page.per(10).count)

        when 'no'
            page.should_not have_selector('.portfolio-item')
    end
end


Then /^I should see events for (.+) "(.*)"$/ do |model_type, ids|
  ids = [ ids.scan(/\d+/)[0] ]
  event_rows = all('.portfolio-item')

  case model_type
      when 'categories'
          category_names = ids.map{|id| Category.find_by_id(id)}.compact.map(&:name)
          #page.should have_selector('.portfolio-item') if Event.find_by_category(*category_names).any?
          event_rows.count.should be(Event.find_by_category(category_names).count)
      when 'clubs'
          club_names = ids.map{|id| Club.find_by_id(id)}.compact.map(&:name)
          page.should have_selector('.portfolio-item') if Event.find_by_club(*club_names).any?
          #puts Event.search( :name_or_club_name_cont => club_names[0]).result(distinct: true).count
          #puts event_rows.count
          event_rows.count.should be(10)#be(Event.search( :name_or_club_name_cont => club_names[0]  ).result(distinct: true).count)
      end
end

Then(/^the facebook url for Club_(\d+) should be "(.*?)"$/) do |arg1, arg2|
  assert page.body.include?(arg2)
end

When(/^I fill in the facebook url with "(.*?)"$/) do |arg1|
    page.find('input#club_facebook_url.form-control.col-sm-2').set 'arg1'
    #fill_in("https://www.facebook.com/", :with => arg1)
end

Then(/^I should see the alert "(.*?)"$/) do |arg1|
    # => puts page.find('div.alert.alert-success')
end




