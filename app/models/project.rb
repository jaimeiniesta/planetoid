class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  validates_presence_of :name, :url
  validates_format_of :url, :with => REXP_URL
  validates_uniqueness_of :url
  
  after_create :twitt
  
  private
  
  # Send a twitter notification if necessary
  def twitt
    if PLANETOID_CONF[:twitter][:projects][:send_twitts]
      begin
        twit=Twitter::Base.new(Twitter::HTTPAuth.new(PLANETOID_CONF[:twitter][:user], PLANETOID_CONF[:twitter][:password]))
        twit.update "#{PLANETOID_CONF[:twitter][:projects][:prefix]} #{self.name} #{self.url}" 
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end
end
