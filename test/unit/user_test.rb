require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def test_fixtures
    User.find(:all).each do |u|
      assert u.valid?
    end
  end
  
  def test_should_create_user
    assert_difference('User.count', +1) do
      create_user
    end
  end
  
  def test_should_validate_presence_of_required_fields
    user = User.new
    assert !user.valid?
    assert_equal user.errors.size, 3
    assert user.errors.on(:name)  # cant be blank
    assert user.errors.on(:email) # cant be blank, format invalid
    
    user.name = "Pepito Grillo"
    user.email = "pepito@example.com"
    assert user.valid?
  end
  
  def test_should_validate_uniqueness_of_fields
    user = User.new(:name => "Pepito Grillo",
                    :email => users(:jaime).email,
                    :blog_url => users(:jaime).blog_url,
                    :twitter_user => users(:jaime).twitter_user,
                    :github_user => users(:jaime).github_user)
    assert !user.valid?
    assert_equal user.errors.size, 4
    assert user.errors.on(:email)
    assert user.errors.on(:blog_url)
    assert user.errors.on(:twitter_user)
    assert user.errors.on(:github_user)
    
    user.email = "pepito@example.com"
    user.blog_url = "http://pepito.jaimeiniesta.com"
    user.twitter_user = "pepito"
    user.github_user = "pepito"
  end
  
  def test_email_should_have_a_valid_format
    user = create_user
    [nil, 'gmail', 'gmail.com', 'jaimeiniesta@gmail', '@gmail.com', 'jaimeiniesta @ gmail.com'].each do |s|
      user.email = s
      assert !user.valid?
      assert user.errors.on(:email)
    end
    
    ['jaimeiniesta@gmail.com', 'pepe@example.com', 'JAIME@EXAMPLE.COM', 'jaime_iniesta@gmail.com', 'jaime.iniesta@gmail.com'].each do |s|
      user.email = s
      assert user.valid?
      assert !user.errors.on(:email)
    end
  end
  
  def test_twitter_user_should_have_a_valid_format
    user = create_user
    ['nickel 83', 'h.ppywebcoder'].each do |s|
      user.twitter_user = s
      assert !user.valid?
      assert user.errors.on(:twitter_user)
    end
    
    ['ji', 'nickel84', 'sepa_rate'].each do |s|
      user.twitter_user = s
      assert user.valid?
      assert !user.errors.on(:twitter_user)
    end
  end
  
  def test_github_user_should_have_a_valid_format
    user = create_user
    ['nickel 84', 'h.ppywebcoder'].each do |s|
      user.github_user = s
      assert !user.valid?
      assert user.errors.on(:github_user)
    end
    
    ['ji', 'nickel84', 'sepa_rate'].each do |s|
      user.github_user = s
      assert user.valid?
      assert !user.errors.on(:github_user)
    end
  end
  
  def test_should_validate_format_of_urls
    # http://en.wikipedia.org/wiki/Hostname#Restrictions_on_valid_host_names
    # RFCs mandate that a hostname's labels may contain only the ASCII letters 'a' through 'z' (case-insensitive), the digits '0' through '9', and the hyphen.
    # Hostname labels cannot begin or end with a hyphen. No other symbols, punctuation characters, or blank spaces are permitted.
    
    u = create_user
    assert u.valid?
    
    [nil, '', 'http://www.example.com', 'http://www.example-with-hyphens.com'].each do |address|
      u.blog_url = address
      assert u.valid?
    end
    
    ['badaddress', 'email@example.com', 'ftp://example.com', 'http://www.example_with_underscore.com', 'http://www.-example.com', 'http://www.example-.com', 'nohttp.com', 'www.nohttp.com', 'http://www.we have spaces.com'].each do |address|
      u.blog_url = address
      assert !u.valid?
    end
  end
  
  def test_should_destroy_user_and_cascade_delete
    assert_difference('User.count', -1) do
      assert_difference('Feed.count', -1) do
        assert_difference('Entry.count', -2) do
          users(:jaime).destroy
        end
      end
    end
  end
  
  def test_should_get_entries_by_user
    assert_equal users(:jaime).entries.count, 2
    [:jaime_blog_1, :jaime_blog_2].each do |e|
      assert users(:jaime).entries.include?(entries(e))
    end
  end
  
  private
  
  def create_user(options = {})
    record = User.new({ :name => 'Pepe Planeta',
                        :email => 'planeta@jaimeiniesta.com',
                        :blog_url => 'http://planeta.jaimeiniesta.com',
                        :twitter_user => 'potipoti',
                        :github_user => 'potipoti' }.merge(options))
    record.save
    record
  end
  
end