# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :club do
    sequence(:name){|c| "Club_#{c}"}
    description{ FactoryGirl.generate(:random_string) }

    factory :club_with_categories, :parent => :club do |club|
      after_create do |club|
      	3.times{ club.categorizations << FactoryGirl.create(:categorization, club: club) }
      end
    end 
  end
end