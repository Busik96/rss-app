# frozen_string_literal: true

# == Schema Information
#
# Table name: feeds
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :feed do
    url { 'https://tvn24.pl/najnowsze.xml' }
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph }
  end

  trait :invalid do
    url { Faker::Internet.url }
  end
end
