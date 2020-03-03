# frozen_string_literal: true

class FeedMailer < ApplicationMailer
  def send_daily_feeds(user, feeds)
    @user = user
    @feeds = feeds

    mail(to: @user.email, subject: 'RSS App - Your daily feeds!')
  end
end
