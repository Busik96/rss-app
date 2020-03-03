# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedsEmailSenderJob, type: :job do
  let(:user) { create :user }
  let!(:user_feed) { user.user_feeds.create(feed_id: feed.id, notify: true) }
  let(:feed) { create :feed }
  let(:last_mail) { ActionMailer::Base.deliveries.last }

  it 'sends email correctly' do
    FeedsEmailSenderJob.perform_now(user)
    expect(last_mail.to.first).to eq(user.email)
    expect(last_mail.subject).to eq('RSS App - Your daily feeds!')
  end
end
