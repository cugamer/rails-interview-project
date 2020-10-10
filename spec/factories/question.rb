FactoryBot.define do
  factory :question do
    title { Faker::Lorem.sentence }
    private { [true, false].sample }

    user
  end
end