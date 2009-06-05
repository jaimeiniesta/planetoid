class EntriesController < ApplicationController  
  # GET /entries
  def index
    @entries = Entry.all(:limit => 100, :order => 'published desc')

    respond_to do |format|
      format.html # index.html.erb
      format.rss # index.rss.builder
    end
  end
end
