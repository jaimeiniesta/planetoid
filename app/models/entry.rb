class Entry < ActiveRecord::Base
  belongs_to :feed
  
  validates_presence_of :feed_id, :url
  validates_uniqueness_of :url
  
  # Send a twitter notification if necessary
  def after_create
    if PLANETOID_CONF[:twitter][:send_updates] && self.published > self.feed.created_at
      twit=Twitter::HTTPAuth.new PLANETOID_CONF[:twitter][:user], PLANETOID_CONF[:twitter][:password]
      twit.update "#{PLANETOID_CONF[:twitter][:update_prefix]} #{self.title[0..150]} #{self.url}" rescue nil
    end
  end
end
