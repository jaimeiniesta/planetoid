class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.integer :user_id
      t.string :title
      t.string :url
      t.string :feed_url
      t.string :etag
      t.datetime :last_modified

      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
