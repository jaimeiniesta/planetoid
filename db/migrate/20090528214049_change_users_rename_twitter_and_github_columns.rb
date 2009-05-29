class ChangeUsersRenameTwitterAndGithubColumns < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.rename :twitter_url, :twitter_user
      t.rename :github_url, :github_user
    end
    
    User.all.each do |user|
      user.github_user.gsub!(GITHUB_URL, '')
      user.twitter_user.gsub!(TWITTER_URL, '')
      user.save
    end
  end

  def self.down
    change_table :users do |t|
      t.rename :twitter_user, :twitter_url
      t.rename :github_user, :github_url
    end  
  end
end
