class AddNotifyToUserFeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :user_feeds, :notify, :boolean
  end
end
