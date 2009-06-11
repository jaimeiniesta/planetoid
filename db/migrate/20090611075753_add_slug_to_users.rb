class AddSlugToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :slug, :string
    add_index :users, :slug
    
    # Generate slugs for existing users
    User.all.each do |user|
      user.save
    end
  end

  def self.down
    remove_index :users, :slug
    remove_column :users, :slug
  end
end

