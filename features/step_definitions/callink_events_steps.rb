Given /^there are no events$/ do
    Event.destroy_all
end
Given /^I am a computer$/ do
    # computers don't  do anything interactive with the web site so this is blank
    # our application focuses extensively on API integration so we have been focusing exclusively on rspec like cucumber tests
end


When /^I parse callink events from todays rss feed$/ do
    FakeWeb.register_uri(:get, 'https://callink.berkeley.edu/EventRss/EventsRss', :body => File.open(Rails.root.join('spec','EventsRss.rss'), "r").read)
    Event.saveCallinkEvents
end
When /^I get a (\d+) when parsing callink events with message "([^"]*)"$/ do |status_code, message|
    message||= "error"
    FakeWeb.register_uri(:get, 'https://callink.berkeley.edu/EventRss/EventsRss',
                         :status => [status_code, message])
end
Then /^there should be (\d+) events$/ do |count|
    expect(Event.count).to eq(count.to_i)
end
