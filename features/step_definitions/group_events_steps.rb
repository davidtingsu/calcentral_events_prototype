Given /I want facebook events for facebook group "([^"]*)"/ do |club_id| end

When /I get facebook events for Facebook Group "([^"]*)" with user access token "([^"]*)"/  do | graph_id, user_access_token|
      url = "https://graph.facebook.com/#{graph_id}/events?access_token=#{user_access_token}"
      body = File.open( File.join(File.expand_path(File.dirname(__FILE__)), "..", "support", "events.json"), "r").read
      FakeWeb.register_uri(:get, url, :body => body)
      club = (Club.find_by_facebook_id(graph_id) or Club.create!(facebook_id: graph_id))
      events = club.get_facebook_group_events(user_access_token)

      if events != nil
        events.data.each{ |event|
            new_event = Event.create!(name: event.name, start_time: event.start_time, end_time: event.end_time, facebook_id: event.id)
            club.events << new_event and club.save!
        }
      end
end

Then /there should be (.*) events for facebook club (.*)/ do |n, facebook_id|
    assert Club.find_by_facebook_id!(facebook_id).events.count == n.to_i, "got #{Club.find_by_facebook_id!(facebook_id).events.count} events instead of #{n} events for club with facebook id #{facebook_id}"
end
