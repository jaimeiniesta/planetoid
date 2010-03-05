class Entry < ActiveRecord::Base
  belongs_to :feed
  
  validates_presence_of :feed_id, :url
  validates_uniqueness_of :url

  after_create :twitt
  
  # Send a twitter notification if necessary
  def twitt
    if PLANETOID_CONF[:twitter][:entries][:send_twitts] && self.published > self.feed.created_at
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
    msg = PLANETOID_CONF[:twitter][:entries][:prefix][0..139]
    
    if msg.length < 135
      msg = msg + " " + self.title[0..(140 - msg.length - 2)]
      
      if msg.length < 140 && self.url.length < (140 - msg.length)
        msg = msg + " " + self.url
      end
    end

    msg
  end
  
end
