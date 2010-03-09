# Defines common twitter functionality for Users, Projects and Entries,
# so they can announce themselves on Twitter
module Twittable
  # Twitter message should be always 140 chars max.
  # Twitter message is generated as prefix + title + url, in this preference order and truncating as needed
  # Prefix will be truncated and take the full 140 chars if needed
  # Title will only be included if there is room for prefix, an space and at least 5 chars for title
  # URL will only be included if there is enough room for prefix, title and itself without truncating
  def twitter_msg    
    msg = PLANETOID_CONF[:twitter][self.class.to_s.pluralize.downcase.to_sym][:prefix][0..139]
    
    if msg.length < 135
      msg = msg + " " + title[0..(140 - msg.length - 2)]
      
      if msg.length < 140 && url.length < (140 - msg.length)
        msg = msg + " " + url
      end
    end

    msg
  end
end