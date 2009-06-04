class WelcomeController < ApplicationController
  
  def index
    # TODO: maybe it would be better to sort them by activity, showing first the ones with recent posts
    @users = User.find(:all, :order => 'name')
    @entries = Entry.find(:all, :limit => 25, :order => 'published desc')
    @projects = Project.find(:all, :order => 'name')
  end

end