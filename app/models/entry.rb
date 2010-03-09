class Entry < ActiveRecord::Base
  include Twittable
  
  belongs_to :feed
  
  validates_presence_of :feed_id, :url
  validates_uniqueness_of :url

  # Overrides definition on Twittable module to add extra condition
  def after_create
    twitt if PLANETOID_CONF[:twitter][:entries][:send_twitts] && self.published > self.feed.created_at
    return nil
  end
  
end
