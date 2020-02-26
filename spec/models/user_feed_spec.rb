# frozen_string_literal: true

# == Schema Information
#
# Table name: user_feeds
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  feed_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_feeds_on_feed_id  (feed_id)
#  index_user_feeds_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (feed_id => feeds.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe UserFeed, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:feed) }
  end
end
