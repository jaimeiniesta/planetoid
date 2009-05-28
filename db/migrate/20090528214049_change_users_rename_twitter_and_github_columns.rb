class ChangeUsersRenameTwitterAndGithubColumns < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.rename :twitter_url, :twitter_user
      t.rename :github_url, :github_user
    end
  end

  def self.down
    change_table :users do |t|
      t.rename :twitter_user, :twitter_url
      t.rename :github_user, :github_url
    end
  end
end
