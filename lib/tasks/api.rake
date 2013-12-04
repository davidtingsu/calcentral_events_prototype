namespace :api do
  desc "sync club and event info"
  task :sync => :environment do
    Club.sync_callink_groups
    Event.saveCallinkEvents
    Club.all.each{ |club|
        club.set_facebook_id!
        club.update_events!
    }
  end

end
