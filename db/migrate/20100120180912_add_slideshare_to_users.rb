class AddSlideshareToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :slideshare_user, :string
  end

  def self.down    
    remove_column :users, :slideshare_user
  end
end