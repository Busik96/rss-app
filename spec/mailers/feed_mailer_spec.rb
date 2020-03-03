# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedMailer, type: :mailer do
  describe 'task_reminder' do
    let(:mail) { FeedMailer.send_daily_feeds(user, user.feeds) }
    let(:feed) { create :feed, user: user }
    let(:user) { create :user }

    it 'renders the headers' do
      expect(mail.subject).to eq('RSS App - Your daily feeds!')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['rss-app@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(user.name)
    end
  end
end
