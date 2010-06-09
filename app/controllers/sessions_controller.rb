class SessionsController < ApplicationController
  def new
    redirect_to '/' if admin?
  end

  def create
    password = PLANETOID_CONF[:admin][:hash_password] == true ? Digest::SHA1.hexdigest(params[:password]) : params[:password]
    if params[:login] == PLANETOID_CONF[:admin][:login].to_s && password == PLANETOID_CONF[:admin][:password].to_s
      session[:admin] = true
      redirect_to '/', :notice => "Welcome, admin!"
    else
      redirect_to '/login', :alert => "Couldn't log you in, please retry"
    end
  end

  def destroy
    reset_session
    redirect_to '/', :notice => "Bye bye!"
  end

end
