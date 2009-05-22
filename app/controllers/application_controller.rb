# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # HTTP authentication for admin sections
  def master_authentication
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == PLANETOID_CONF[:admin][:login].to_s && password == PLANETOID_CONF[:admin][:password].to_s
    end unless RAILS_ENV == 'test'
  end
  
  # Quick and dirty admin login to set a session variable
  def admin_login
    session[:admin] = true
  end
end
