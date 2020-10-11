# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { Faker::Lorem.sentence }
    private { [true, false].sample }

    user
  end
end
