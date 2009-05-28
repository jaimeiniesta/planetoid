require 'test_helper'

class FeedTest < ActiveSupport::TestCase

  def test_fixtures
    Feed.find(:all).each do |f|
      assert f.valid?
    end
  end
  
  def test_should_create_feed_and_fetch_entries
    assert_difference('Feed.count', +1) do
      assert_difference('Entry.count', +28) do #TODO: check there is any difference, not this exact amount
        create_feed
      end
    end
  end
  
  def test_should_validate_presence_of_required_fields
     feed = Feed.new
     assert !feed.valid?
     assert_equal feed.errors.size, 3
     assert feed.errors.on(:user_id)  # cant be blank
     assert feed.errors.on(:feed_url) # cant be blank, format invalid

     feed.user = users(:jaime)
     feed.feed_url = "http://feeds.feedburner.com/PageRankAlert"
     assert feed.valid?
  end  

  def test_should_validate_uniqueness_of_fields
    feed = Feed.new(:user_id => users(:emili).to_param, :feed_url => feeds(:jaime_blog).feed_url)
    assert !feed.valid?
    assert feed.errors.on(:feed_url)
    
    feed.feed_url="http://www.example.com/feed"
    assert feed.valid?
  end
  
  def test_should_validate_format_of_url
    # http://en.wikipedia.org/wiki/Hostname#Restrictions_on_valid_host_names
    # RFCs mandate that a hostname's labels may contain only the ASCII letters 'a' through 'z' (case-insensitive), the digits '0' through '9', and the hyphen.
    # Hostname labels cannot begin or end with a hyphen. No other symbols, punctuation characters, or blank spaces are permitted.
    
    feed = Feed.new(:user_id => users(:emili).to_param, :feed_url => "http://www.example.com/feed")
    assert feed.valid?
    
    ['http://www.example.com', 'http://www.example-with-hyphens.com'].each do |address|
      feed.feed_url = address
      assert feed.valid?
    end
    
    [nil, '', 'badaddress', 'email@example.com', 'ftp://example.com', 'http://www.example_with_underscore.com', 'http://www.-example.com', 'http://www.example-.com', 'nohttp.com', 'www.nohttp.com', 'http://www.we have spaces.com'].each do |address|
      feed.feed_url = address
      assert !feed.valid?
    end
  end

  private
  
  def create_feed(options = {})
    record = Feed.new({ :user_id => users(:jaime).id,
                        :feed_url => "http://feeds.feedburner.com/PageRankAlert" }.merge(options))
    record.save
    record
  end
  
end
