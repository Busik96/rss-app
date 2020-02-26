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
class UserFeed < ApplicationRecord
  belongs_to :user
  belongs_to :feed
end
