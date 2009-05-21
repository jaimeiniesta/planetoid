class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :feed_id
      t.string :title
      t.string :url
      t.string :author
      t.text :summary
      t.text :content
      t.datetime :published
      t.string :categories

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
