# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :club do
    sequence(:name){|c| "Club_#{c}"}
    description{ FactoryGirl.generate(:random_string) }

    factory :club_with_categories, :parent => :club do |club|
      categories { FactoryGirl.build_list :category, 3 }
    end 
  end
end
