# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduleDailyEmailsJob, type: :job do
  let(:user) { create :user }
  let(:user2) { create :user }
  let!(:user_feed) { user.user_feeds.create(feed_id: feed1.id, notify: true) }
  let!(:user_feed2) { user2.user_feeds.create(feed_id: feed2.id, notify: false) }
  let(:feed1) { create :feed }
  let(:feed2) { create :feed, url: 'http://fakty.interia.pl/feed' }
  subject(:call) { ScheduleDailyEmailsJob.perform_now }

  it 'sends email with correct feed' do
    expect { call }.to have_enqueued_job.with(user)
  end

  it 'not send email with incorrect feed' do
    expect { call }.not_to have_enqueued_job.with(user2)
  end
end
