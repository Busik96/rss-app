class CreateUserFeeds < ActiveRecord::Migration[6.0]
  def change
    create_table :user_feeds do |t|
      t.references :user, null: false, foreign_key: true
      t.references :feed, null: false, foreign_key: true

      t.timestamps
    end
  end
end
