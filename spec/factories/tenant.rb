# frozen_string_literal: true

FactoryBot.define do
  factory :tenant do
    name { Faker::Name.name }
  end
end
