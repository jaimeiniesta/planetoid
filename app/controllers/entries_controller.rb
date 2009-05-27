class EntriesController < ApplicationController
  before_filter :admin_required
  
  # GET /entries
  def index
    @entries = Entry.all(:order => 'published desc')

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /entries/1
  def show
    @entry = Entry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # DELETE /entries/1
  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to(entries_url) }
    end
  end
end
