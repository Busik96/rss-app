# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'rss-app@example.com'
  layout 'mailer'
end
