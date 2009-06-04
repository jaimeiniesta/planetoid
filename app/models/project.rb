class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  validates_presence_of :name, :url
  validates_format_of :url, :with => REXP_URL
  validates_uniqueness_of :url
end
