FactoryGirl.define do
  factory :categorization do
    club{ Factory.create(:club) }
    category{ Factory.create(:category) }
  end
end
