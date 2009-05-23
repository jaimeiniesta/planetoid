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
  
  private
  
  def create_entry(options = {})
    record = Entry.new({:feed_id => feeds(:jaime_blog).id,
                        :url => 'http://www.example.com',
                        :author => 'Jaime Iniesta',
                        :title => 'Another entry',
                        :summary => 'The summary',
                        :content => 'The content is usually longer than the summary',
                        :published => 3.days.ago,
                        :categories => 'ruby, rails, web development'}.merge(options))
    record.save
    record
  end
  
end