FactoryGirl.define do
  sequence(:random_word)      { Faker::Lorem.word }
  sequence(:random_string)      { Faker::Lorem.sentence }
  sequence(:random_description) { Faker::Lorem.paragraphs(1 + Kernel.rand(5)).join("\n") }
  sequence(:random_email)       { Faker::Internet}
end

