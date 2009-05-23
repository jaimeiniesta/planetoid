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
                    :twitter_url => users(:jaime).twitter_url,
                    :github_url => users(:jaime).github_url)
    assert !user.valid?
    assert_equal user.errors.size, 4
    assert user.errors.on(:email)
    assert user.errors.on(:blog_url)
    assert user.errors.on(:twitter_url)
    assert user.errors.on(:github_url)
    
    user.email = "pepito@example.com"
    user.blog_url = "http://pepito.jaimeiniesta.com"
    user.twitter_url = "http://twitter.com/pepito"
    user.github_url = "http://github.com/pepito"
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
  
  private
  
  def create_user(options = {})
    record = User.new({ :name => 'Pepe Planeta',
                        :email => 'planeta@jaimeiniesta.com',
                        :blog_url => 'http://planeta.jaimeiniesta.com',
                        :twitter_url => 'http://twitter.com/potipoti',
                        :github_url => 'http://github.com/potipoti' }.merge(options))
    record.save
    record
  end
  
end