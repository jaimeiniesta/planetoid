class FeedsController < ApplicationController
  before_filter :admin_required
    
  # GET /feeds
  def index
    @feeds = Feed.all(:order => 'last_modified desc')

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /feeds/1
  def show
    @feed = Feed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /feeds/new
  def new
    @feed = Feed.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /feeds/1/edit
  def edit
    @feed = Feed.find(params[:id])
  end

  # POST /feeds
  def create
    @feed = Feed.new(params[:feed])

    respond_to do |format|
      if @feed.save
        flash[:notice] = 'Feed was successfully created.'
        format.html { redirect_to(@feed) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /feeds/1
  def update
    @feed = Feed.find(params[:id])

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        flash[:notice] = 'Feed was successfully updated.'
        format.html { redirect_to(@feed) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /feeds/1
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to(feeds_url) }
    end
  end
end
