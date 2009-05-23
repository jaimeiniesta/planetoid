class User < ActiveRecord::Base
  has_many :feeds, :dependent => :destroy
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  validates_uniqueness_of :blog_url, :twitter_url, :github_url, :allow_nil => true, :allow_blank => true
  validates_format_of :email, :with => REXP_EMAIL
  validates_format_of :blog_url, :with => REXP_URL, :allow_nil => true, :allow_blank => true
  validates_format_of :twitter_url, :with => REXP_URL, :allow_nil => true, :allow_blank => true
  validates_format_of :github_url, :with => REXP_URL, :allow_nil => true, :allow_blank => true
end
