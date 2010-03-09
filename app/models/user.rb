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
  validates_format_of :delicious_user, :with => REXP_DELICIOUS_USER, :allow_blank => true  
    
  validates_uniqueness_of :email, :allow_blank => true
  validates_uniqueness_of :blog_url, :twitter_user, :github_user, :slideshare_user, :delicious_user, :allow_blank => true
  
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
  
  # Returns the full delicious URL for this user if has a delicious user, or nil if not
  def delicious_url
    delicious_user.blank? ? nil : "#{DELICIOUS_URL}#{delicious_user}"
  end
  
  # Use user's name as its title
  def title
    name
  end
  
  # Return url of this user's profile
  def url
    "#{PLANETOID_CONF[:site][:url]}/#{slug}"
  end
  
  # Send a twitter notification if necessary
  def twitt
    if PLANETOID_CONF[:twitter][:users][:send_twitts]
      begin
        twit=Twitter::Base.new(Twitter::HTTPAuth.new(PLANETOID_CONF[:twitter][:user], PLANETOID_CONF[:twitter][:password]))
        twit.update twitter_msg 
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end  
  
  # Twitter message should be always 140 chars max.
  # Twitter message is generated as prefix + title + url, in this preference order and truncating as needed
  # Prefix will be truncated and take the full 140 chars if needed
  # Title will only be included if there is room for prefix, an space and at least 5 chars for title
  # URL will only be included if there is enough room for prefix, title and itself without truncating
  def twitter_msg    
    msg = PLANETOID_CONF[:twitter][:users][:prefix][0..139]
    
    if msg.length < 135
      msg = msg + " " + title[0..(140 - msg.length - 2)]
      
      if msg.length < 140 && url.length < (140 - msg.length)
        msg = msg + " " + url
      end
    end

    msg
  end

end
