# frozen_string_literal: true

class FeedsEmailSenderJob < ApplicationJob
  queue_as :mailers

  def perform(user)
    FeedMailer.send_daily_feeds(user, user.daily_feeds).deliver_now
  end
end
