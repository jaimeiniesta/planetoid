class Project < ActiveRecord::Base
  include Twittable
  
  has_and_belongs_to_many :users
  
  validates_presence_of :name, :url
  validates_format_of :url, :with => REXP_URL
  validates_uniqueness_of :url
  
  after_create :twitt
  
  # Use project's name as its title
  def title
    name
  end
  
  # Send a twitter notification if necessary
  def twitt
    if PLANETOID_CONF[:twitter][:projects][:send_twitts]
      begin
        twit=Twitter::Base.new(Twitter::HTTPAuth.new(PLANETOID_CONF[:twitter][:user], PLANETOID_CONF[:twitter][:password]))
        twit.update twitter_msg
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end
  
end
