# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { Faker::Lorem.sentence }

    user
    question
  end
end
