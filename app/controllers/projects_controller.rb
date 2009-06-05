class ProjectsController < ApplicationController
  before_filter :admin_required, :except => [:index, :show]  
  
  # GET /projects
  def index
    @projects = Project.all(:order => :name)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /projects/1
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /projects/new
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(@project) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /projects/1
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(@project) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /projects/1
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
    end
  end
end
