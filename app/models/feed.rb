class Feed < ActiveRecord::Base
  belongs_to :user
  has_many :entries, :dependent => :destroy
  after_create :fetch!
  
  validates_presence_of :user_id, :feed_url
  validates_uniqueness_of :feed_url
  validates_format_of :feed_url, :with => REXP_URL
  
  #
  # Fetch feed, update attibutes and create entries
  #
  def fetch!
    parsed_feed = Feedzirra::Feed.fetch_and_parse(self.feed_url)
    
    self.update_attributes( :title => parsed_feed.title,
                            :url => parsed_feed.url,
                            :etag => parsed_feed.etag,
                            :last_modified => parsed_feed.last_modified)
                            
    parsed_feed.entries.each do |entry|
      self.entries.create(:url => entry.url,
                          :title => entry.title,
                          :author => entry.author,
                          :summary => entry.summary,
                          :content => entry.content,
                          :published => entry.published,
                          :categories => entry.categories) if !Entry.find_by_url(entry.url)
    end
  end
  
  #
  # Fetch all feeds
  #
  def self.fetch_all!
    Feed.find(:all).each do |f|
      f.fetch!
    end
  end
end
