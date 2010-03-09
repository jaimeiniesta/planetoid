class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  validates_presence_of :name, :url
  validates_format_of :url, :with => REXP_URL
  validates_uniqueness_of :url
  
  after_create :twitt
  
  # Use project's name as its title
  def title
    name
  end
  
  # Send a twitter notification if necessary
  def twitt
    if PLANETOID_CONF[:twitter][:projects][:send_twitts]
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
    msg = PLANETOID_CONF[:twitter][:projects][:prefix][0..139]
    
    if msg.length < 135
      msg = msg + " " + title[0..(140 - msg.length - 2)]
      
      if msg.length < 140 && url.length < (140 - msg.length)
        msg = msg + " " + url
      end
    end

    msg
  end
  
end
