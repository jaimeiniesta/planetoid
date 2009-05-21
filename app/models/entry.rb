class Entry < ActiveRecord::Base
  belongs_to :feed
  validates_presence_of :feed_id, :url
  validates_uniqueness_of :url
end
