require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  
  def test_fixtures
    Entry.find(:all).each do |e|
      assert e.valid?
    end
  end
  
  def test_should_create_entry
    assert_difference('Entry.count', +1) do
      create_entry
    end
  end
  
  def test_should_generate_twitter_msg_as_prefix_title_url
    prefix = PLANETOID_CONF[:twitter][:entries][:prefix]
    entry = new_entry

    assert_equal 46, entry.twitter_msg.length
    assert_equal "#{prefix} #{entry.title} #{entry.url}", entry.twitter_msg
  end

  def test_should_use_only_prefix_if_no_room_for_title
    prefix = PLANETOID_CONF[:twitter][:entries][:prefix] = "A"*140
    entry = new_entry
    
    assert_equal 140, entry.twitter_msg.length
    assert_equal "#{prefix}", entry.twitter_msg
  end

  def test_should_truncate_prefix_if_needed
    prefix = PLANETOID_CONF[:twitter][:entries][:prefix] = "A"*141
    entry = new_entry
    
    assert_equal 140, entry.twitter_msg.length
    assert_equal "#{prefix[0..139]}", entry.twitter_msg
  end
  
  def test_should_not_include_title_if_there_is_no_space_for_prefix_one_space_and_5_chars_for_title
    prefix = PLANETOID_CONF[:twitter][:entries][:prefix] = "A"*135
    entry = new_entry(:title => "B"*5)
    
    assert_equal 135, entry.twitter_msg.length
    assert_equal "#{prefix}", entry.twitter_msg
  end
  
  def test_should_include_title_if_there_is_space_for_prefix_one_space_and_5_chars_for_title
    prefix = PLANETOID_CONF[:twitter][:entries][:prefix] = "A"*134
    entry = new_entry(:title => "B"*5)
    
    assert_equal 140, entry.twitter_msg.length
    assert_equal "#{prefix} #{entry.title}", entry.twitter_msg
  end
  
  def test_should_truncate_title_if_needed
    prefix = PLANETOID_CONF[:twitter][:entries][:prefix] = "A"*130
    entry = new_entry(:title => "B"*10)
    
    assert_equal 140, entry.twitter_msg.length
    assert_equal "#{prefix} #{entry.title[0..8]}", entry.twitter_msg
  end
  
  def test_should_include_url_if_there_is_enough_room
    prefix = PLANETOID_CONF[:twitter][:entries][:prefix] = "A"*111
    entry = new_entry(:title => "B"*5)
    
    assert_equal 140, entry.twitter_msg.length
    assert_equal "#{prefix} #{entry.title} #{entry.url}", entry.twitter_msg
  end
  
  def test_should_not_include_url_if_there_is_not_enough_room
    prefix = PLANETOID_CONF[:twitter][:entries][:prefix] = "A"*112
    entry = new_entry(:title => "B"*5)
    
    assert_equal 118, entry.twitter_msg.length
    assert_equal "#{prefix} #{entry.title}", entry.twitter_msg
  end
  
  private
  
  def new_entry(options = {})
    record = Entry.new({:feed_id => feeds(:jaime_blog).id,
                        :url => 'http://www.example.com',
                        :author => 'Jaime Iniesta',
                        :title => 'Another entry',
                        :summary => 'The summary',
                        :content => 'The content is usually longer than the summary',
                        :published => 3.days.ago,
                        :categories => 'ruby, rails, web development'}.merge(options))
  end
  
  def create_entry(options = {})
    record = new_entry(options)
    record.save
    record
  end
  
end