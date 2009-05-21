class User < ActiveRecord::Base
  has_many :feeds, :dependent => :destroy
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  validates_uniqueness_of :blog_url, :twitter_url, :github_url, :allow_nil => true, :allow_blank => true
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_format_of :blog_url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix, :allow_nil => true, :allow_blank => true
  validates_format_of :twitter_url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix, :allow_nil => true, :allow_blank => true
  validates_format_of :github_url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix, :allow_nil => true, :allow_blank => true
end
