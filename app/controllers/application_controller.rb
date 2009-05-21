# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # HTTP authentication used to protect staging of curious eyes
  # TODO: move login and password to a config file
  def master_authentication
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == "admin" && password == "1234"
    end unless RAILS_ENV == 'test'
  end
  
  # Quick and dirty admin login to set a session variable
  def admin_login
    session[:admin] = true
  end
end
