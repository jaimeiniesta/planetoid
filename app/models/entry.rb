class Entry < ActiveRecord::Base
  belongs_to :feed
  
  validates_presence_of :feed_id, :url
  validates_uniqueness_of :url

  after_create :twitt

  private
  
  after_create :twitt
  
  private
  
  # Send a twitter notification if necessary
  def twitt
    if PLANETOID_CONF[:twitter][:entries][:send_twitts] && self.published > self.feed.created_at
      twit=Twitter::Base.new(Twitter::HTTPAuth.new(PLANETOID_CONF[:twitter][:user], PLANETOID_CONF[:twitter][:password]))
      twit.update "#{PLANETOID_CONF[:twitter][:entries][:prefix]} #{self.title[0..150]} #{self.url}"
    end
  end
end
