# Defines common twitter functionality for Users, Projects and Entries,
# so they can announce themselves on Twitter
module Twittable
  
  # Announce creation on twitter if so specified on planetoid options
  # Override this on your model if you need extra conditions
  def after_create
    twitt if PLANETOID_CONF[:twitter][config_key_for_class][:send_twitts]
    return nil
  end
  
  # Returns shortened URL using the J.mp (bit.ly) external service
  # If so specified on planetoid options
  def short_url
    if PLANETOID_CONF[:bitly][:activated]
      begin
        bitly = Bitly.new(PLANETOID_CONF[:bitly][:login], PLANETOID_CONF[:bitly][:api_key])
        bitly.shorten(url).jmp_url
      rescue
        url
      end
    else
      url
    end
  end
  
  # Send a twitter notification
  def twitt
    begin
      twit=Twitter::Base.new(Twitter::HTTPAuth.new(PLANETOID_CONF[:twitter][:user], PLANETOID_CONF[:twitter][:password]))
      twit.update twitter_msg 
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
    end
  end
  
  # Twitter message should be always 140 chars max.
  # Twitter message is generated as prefix + title + url, in this preference order and truncating as needed
  # Prefix will be truncated and take the full 140 chars if needed
  # Title will only be included if there is room for prefix, an space and at least 5 chars for title
  # URL will only be included if there is enough room for prefix, title and itself without truncating
  def twitter_msg
    msg = PLANETOID_CONF[:twitter][config_key_for_class][:prefix][0..139]
    
    if msg.length < 135
      msg = msg + " " + title[0..(140 - msg.length - 2)]
      
      if msg.length < 140 && short_url.length < (140 - msg.length)
        msg = msg + " " + short_url
      end
    end

    msg
  end
  
  private
  
  # Returns the key to be used on the planetoid config file for this class
  # User => :users
  # Entry => :entries
  # Project => :projects
  def config_key_for_class
    self.class.to_s.pluralize.downcase.to_sym
  end
end