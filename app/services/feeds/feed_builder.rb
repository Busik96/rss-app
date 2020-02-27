# frozen_string_literal: true

module Feeds
  class FeedBuilder
    def call(url)
      feed = existing_feed(url)
      return feed if feed.present?

      rss_body = load_rss_body(url)
      create_feed_from_details(url, rss_body)
    end

    private

    def create_feed_from_details(url, rss_body)
      details = Feedjira.parse(rss_body)

      Feed.create!(
        url: url,
        title: details.title,
        description: details.description
      )
    end

    def load_rss_body(url)
      Rails.cache.fetch(Feed.cache_key(url), expires: 10.minutes) do
        HTTParty.get(url).body
      end
    end

    def existing_feed(url)
      Feed.where(url: url).first
    end
  end
end
