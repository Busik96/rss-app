# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/feeds_mailer
class FeedsMailerPreview < ActionMailer::Preview
  def send_daily_feeds
    ::FeedMailer.send_daily_feeds(User.first, Feed.all)
  end
end
