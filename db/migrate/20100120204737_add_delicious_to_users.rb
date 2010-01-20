class AddDeliciousToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :delicious_user, :string
  end

  def self.down    
    remove_column :users, :delicious_user
  end
end
