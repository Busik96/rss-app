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
class Feed < ApplicationRecord
  has_many :user_feeds

  validates :url, presence: true

  def self.cache_key(url)
    "feed-#{Digest::MD5.hexdigest(url)}"
  end

  def details
    rss = HTTParty.get(url).body
    Feedjira.parse(rss)
  end
end
