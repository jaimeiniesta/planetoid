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
    assert_equal user.errors.size, 1
    assert user.errors.on(:name)  # cant be blank
    
    user.name = "Pepito Grillo"
    user.email = "pepito@example.com"
    assert user.valid?
  end
  
  def test_should_validate_uniqueness_of_fields
    user = User.new(:name => "Pepito Grillo",
                    :email => users(:jaime).email,
                    :blog_url => users(:jaime).blog_url,
                    :twitter_user => users(:jaime).twitter_user,
                    :github_user => users(:jaime).github_user,
                    :slideshare_user => users(:jaime).slideshare_user)
    assert !user.valid?
    assert_equal user.errors.size, 5
    assert user.errors.on(:email)
    assert user.errors.on(:blog_url)
    assert user.errors.on(:twitter_user)
    assert user.errors.on(:github_user)
    assert user.errors.on(:slideshare_user)
    
    user.email = "pepito@example.com"
    user.blog_url = "http://pepito.jaimeiniesta.com"
    user.twitter_user = "pepito"
    user.github_user = "pepito"
    user.slideshare_user = "pepito"
    assert user.valid?
  end
  
  def test_email_should_have_a_valid_format
    user = create_user
    ['gmail', 'gmail.com', 'jaimeiniesta@gmail', '@gmail.com', 'jaimeiniesta @ gmail.com'].each do |s|
      user.email = s
      assert !user.valid?
      assert user.errors.on(:email)
    end
    
    [nil, '', 'jaimeiniesta@gmail.com', 'pepe@example.com', 'JAIME@EXAMPLE.COM', 'jaime_iniesta@gmail.com', 'jaime.iniesta@gmail.com'].each do |s|
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
    
    ['ji', 'nickel84', 'sepa_rate', 'ernesto-jimenez'].each do |s|
      user.github_user = s
      assert user.valid?
      assert !user.errors.on(:github_user)
    end
  end
  
  def test_slideshare_user_should_have_a_valid_format
    user = create_user
    ['nickel 84', 'h.ppywebcoder', 'sepa_rate', 'ernesto-jimenez'].each do |s|
      user.slideshare_user = s
      assert !user.valid?
      assert user.errors.on(:slideshare_user)
    end
    
    ['ji', 'nickel84'].each do |s|
      user.slideshare_user = s
      assert user.valid?
      assert !user.errors.on(:slideshare_user)
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
  
  def test_should_get_twitter_url
    assert_equal "http://twitter.com/jaimeiniesta", users(:jaime).twitter_url
    assert_nil users(:notdeveloper).twitter_url
  end
  
  def test_should_get_github_url
    assert_equal "http://github.com/jaimeiniesta", users(:jaime).github_url
    assert_nil users(:notdeveloper).github_url
  end
  
  def test_should_get_slideshare_url
    assert_equal "http://slideshare.net/jaimeiniesta", users(:jaime).slideshare_url
    assert_nil users(:notdeveloper).slideshare_url
  end
  
  def test_should_create_slug
    user = create_user
    assert_equal user.slug, 'pepe-planeta'
  end
  
  def test_should_not_repeat_slug
    user = create_user(:name => 'Jaime Iniesta')
    assert_equal user.slug, 'jaime-iniesta-2'
  end
  
  private
  
  def create_user(options = {})
    record = User.new({ :name => 'Pepe Planeta',
                        :email => 'planeta@jaimeiniesta.com',
                        :blog_url => 'http://planeta.jaimeiniesta.com',
                        :twitter_user => 'potipoti',
                        :github_user => 'potipoti',
                        :slideshare_user => 'potipoti' }.merge(options))
    record.save
    record
  end
  
end