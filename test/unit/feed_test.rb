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
    # TODO
  end
  
  def test_should_validate_format_of_url
    # TODO
  end

  private
  
  def create_feed(options = {})
    record = Feed.new({ :user_id => users(:jaime).id,
                        :feed_url => "http://feeds.feedburner.com/PageRankAlert" }.merge(options))
    record.save
    record
  end
  
end
