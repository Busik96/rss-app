# frozen_string_literal: true

class ScheduleDailyEmailsJob < ApplicationJob
  queue_as :default

  def perform
    User.joins(:daily_feeds).each do |user|
      FeedsEmailSenderJob.perform_later(user)
    end
  end
end
