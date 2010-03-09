class Entry < ActiveRecord::Base
  include Twittable
  
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
  
end
