class User < ActiveRecord::Base
  has_many :feeds, :dependent => :destroy
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  validates_uniqueness_of :blog_url, :twitter_user, :github_user, :allow_blank => true
  validates_format_of :email, :with => REXP_EMAIL
  validates_format_of :blog_url, :with => REXP_URL, :allow_blank => true
  validates_format_of :twitter_user, :github_user, :with => REXP_USER, :allow_blank => true
  
  # Both methods to maintain compatibility with previous code  
  def github_url
    GITHUB_URL + github_user
  end
  
  def twitter_url
    TWITTER_URL + twitter_user
  end
end
