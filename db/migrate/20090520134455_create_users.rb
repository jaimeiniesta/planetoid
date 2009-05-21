class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :blog_url
      t.string :twitter_url
      t.string :github_url

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
