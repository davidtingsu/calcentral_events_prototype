# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    sequence(:start_time) {|c| Time.now + c.day}
    sequence(:end_time) {|c| Time.now + c.day + c.hours }
    sequence(:name){|c| "Event_#{c}"}
   
    factory :event_with_club, :parent => :event do |event|
        club { FactoryGirl.create(:club) }
    end
  end
end
