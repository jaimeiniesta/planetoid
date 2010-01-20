class User < ActiveRecord::Base
  has_many :feeds, :order => :title, :dependent => :destroy
  has_many :entries, :through => :feeds, :order => 'entries.published DESC'
  
  has_and_belongs_to_many :projects, :order => 'projects.name'
  
  validates_presence_of :name

  validates_format_of :email, :with => REXP_EMAIL, :allow_blank => true
  validates_format_of :blog_url, :with => REXP_URL, :allow_blank => true
  validates_format_of :twitter_user, :with => REXP_TWITTER_USER, :allow_blank => true
  validates_format_of :github_user, :with => REXP_GITHUB_USER, :allow_blank => true
  validates_format_of :slideshare_user, :with => REXP_SLIDESHARE_USER, :allow_blank => true  
  
  validates_uniqueness_of :email, :allow_blank => true
  validates_uniqueness_of :blog_url, :twitter_user, :github_user, :slideshare_user, :allow_blank => true
  
  sluggable_finder :name
  
  after_create :twitt
  
  # Returns the full github URL for this user if has a github user, or nil if not
  def github_url
    github_user.blank? ? nil : "#{GITHUB_URL}#{github_user}"
  end
  
  # Returns the full twitter URL for this user if has a twitter user, or nil if not
  def twitter_url
    twitter_user.blank? ? nil : "#{TWITTER_URL}#{twitter_user}"
  end
  
  # Returns the full slideshare URL for this user if has a slideshare user, or nil if not
  def slideshare_url
    slideshare_user.blank? ? nil : "#{SLIDESHARE_URL}#{slideshare_user}"
  end
  
  private
  
  # Send a twitter notification if necessary
  def twitt
    if PLANETOID_CONF[:twitter][:users][:send_twitts]
      twit=Twitter::Base.new(Twitter::HTTPAuth.new(PLANETOID_CONF[:twitter][:user], PLANETOID_CONF[:twitter][:password]))
      twit.update "#{PLANETOID_CONF[:twitter][:users][:prefix]} #{self.name} #{PLANETOID_CONF[:site][:url]}/#{self.slug}" 
    end
  end  

end
