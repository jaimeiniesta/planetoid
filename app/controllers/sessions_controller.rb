class SessionsController < ApplicationController
  def new
    redirect_to '/' if admin?
  end

  def create
    password = PLANETOID_CONF[:admin][:hash_password] == true ? Digest::SHA1.hexdigest(params[:password]) : params[:password]
    if params[:login] == PLANETOID_CONF[:admin][:login].to_s && password == PLANETOID_CONF[:admin][:password].to_s
      session[:admin] = true
      flash[:notice] = "Welcome, admin!"
      redirect_to '/'
    else
      flash[:error] = "Couldn't log you in, please retry"
      redirect_to '/login'
    end
  end

  def destroy
    reset_session
    flash[:notice] = "Bye bye!"
    redirect_to '/'
  end

end
