# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    sequence(:name){|n| (FactoryGirl.generate(:random_word)+"_#{n}").capitalize! }
  end
end
