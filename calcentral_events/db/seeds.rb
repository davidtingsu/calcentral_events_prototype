# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


5.times{
  club = FactoryGirl.create(:club_with_categories)
  3.times{
    FactoryGirl.create(:event_with_club, club: club)
    }
}
