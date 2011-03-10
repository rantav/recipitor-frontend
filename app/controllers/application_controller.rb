class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :redirect_to_ssl

  def redirect_to_ssl
    redirect_to :protocol => "https://" unless (request.ssl? or !env_production?)
  end

  def env_production?
    ENV['RAILS_ENV'] == "production"
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

protected

  def authenticate_inviter!
    (current_user && current_user.admin?) || redirect_to(root_url, :alert => "Sorry, you can't invite new users just yet...")
  end
  
  def check_admin_ability
    redirect_to root_path unless can? :admin, :all
  end
end
