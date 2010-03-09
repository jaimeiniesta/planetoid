require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  
  def test_fixtures
    Project.find(:all).each do |p|
      assert p.valid?
    end
  end
  
  def test_required_fields
    p = Project.new
    assert !p.valid?
    assert p.errors.on(:name)
    assert p.errors.on(:url)
    
    p.name = "An interesting project"
    p.url = "http://www.example.com/newprojectinteresting"
    assert p.valid?
    assert !p.errors.on(:name)
    assert !p.errors.on(:url)
  end
  
  def test_format_of_url
    # http://en.wikipedia.org/wiki/Hostname#Restrictions_on_valid_host_names
    # RFCs mandate that a hostname's labels may contain only the ASCII letters 'a' through 'z' (case-insensitive), the digits '0' through '9', and the hyphen.
    # Hostname labels cannot begin or end with a hyphen. No other symbols, punctuation characters, or blank spaces are permitted.
    
    p = Project.new(:name => 'An interesting project', :url => 'http://www.validurl.com')
    assert p.valid?
    
    ['http://www.example.com', 'http://www.example-with-hyphens.com', 'http://www.example.com/with/subdirs/'].each do |address|
      p.url = address
      assert p.valid?
    end
    
    [nil, '', 'badaddress', 'email@example.com', 'ftp://example.com', 'http://www.example_with_underscore.com', 'http://www.-example.com', 'http://www.example-.com', 'nohttp.com', 'www.nohttp.com', 'http://www.we have spaces.com'].each do |address|
      p.url = address
      assert !p.valid?
    end
  end
  
  def test_should_validate_uniqueness_of_url
    p=Project.new(:name => 'An interesting project', :url => projects(:metainspector).url)
    assert !p.valid?
    assert p.errors.on(:url)
    p.url = 'http://www.example.com'
    assert p.valid?
  end
  
  def test_a_project_has_and_belongs_to_many_users
    assert_equal projects(:planetoid).users.size, 2
    [users(:jaime), users(:juan)].each do |user|
      assert projects(:planetoid).users.include?(user)
    end
    
    assert_equal users(:jaime).projects.size, 2
    [projects(:planetoid), projects(:metainspector)].each do |project|
      assert users(:jaime).projects.include?(project)
    end
  end
  
  def test_should_use_name_as_title
    assert_equal projects(:planetoid).name, projects(:planetoid).title
  end
  
  def test_should_generate_twitter_msg_as_prefix_name_url
    prefix = PLANETOID_CONF[:twitter][:projects][:prefix]
    project = new_project

    assert_equal 67, project.twitter_msg.length
    assert_equal "#{prefix} #{project.name} #{project.url}", project.twitter_msg
  end

  def test_should_use_only_prefix_if_no_room_for_name
    prefix = PLANETOID_CONF[:twitter][:projects][:prefix] = "A"*140
    project = new_project
    
    assert_equal 140, project.twitter_msg.length
    assert_equal "#{prefix}", project.twitter_msg
  end

  def test_should_truncate_prefix_if_needed
    prefix = PLANETOID_CONF[:twitter][:projects][:prefix] = "A"*141
    project = new_project
    
    assert_equal 140, project.twitter_msg.length
    assert_equal "#{prefix[0..139]}", project.twitter_msg
  end
  
  def test_should_not_include_name_if_there_is_no_space_for_prefix_one_space_and_5_chars_for_name
    prefix = PLANETOID_CONF[:twitter][:projects][:prefix] = "A"*135
    project = new_project(:name => "B"*5)
    
    assert_equal 135, project.twitter_msg.length
    assert_equal "#{prefix}", project.twitter_msg
  end
  
  def test_should_include_name_if_there_is_space_for_prefix_one_space_and_5_chars_for_name
    prefix = PLANETOID_CONF[:twitter][:projects][:prefix] = "A"*134
    project = new_project(:name => "B"*5)
    
    assert_equal 140, project.twitter_msg.length
    assert_equal "#{prefix} #{project.name}", project.twitter_msg
  end
  
  def test_should_truncate_name_if_needed
    prefix = PLANETOID_CONF[:twitter][:projects][:prefix] = "A"*130
    project = new_project(:name => "B"*10)
    
    assert_equal 140, project.twitter_msg.length
    assert_equal "#{prefix} #{project.name[0..8]}", project.twitter_msg
  end
  
  def test_should_include_url_if_there_is_enough_room
    prefix = PLANETOID_CONF[:twitter][:projects][:prefix] = "A"*94
    project = new_project(:name => "B"*10)

    assert_equal 140, project.twitter_msg.length
    assert_equal "#{prefix} #{project.name} #{project.url}", project.twitter_msg
  end
  
  def test_should_not_include_url_if_there_is_not_enough_room
    prefix = PLANETOID_CONF[:twitter][:projects][:prefix] = "A"*112
    project = new_project(:name => "B"*5)
    
    assert_equal 118, project.twitter_msg.length
    assert_equal "#{prefix} #{project.name}", project.twitter_msg
  end
  
  private
  
  def new_project(options = {})
    record = Project.new({  :name => 'A brand new project',
                            :url => 'http://example.com/brandnewproject' }.merge(options))
    record
  end
  
end
