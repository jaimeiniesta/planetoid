class WelcomeController < ApplicationController
  
  def index
    # TODO: maybe it would be better to sort them by activity, showing first the ones with recent posts
    @users = User.find(:all, :order => 'rand()')
    @entries = Entry.find(:all, :limit => 25, :order => 'published desc')
  end

end
