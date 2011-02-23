class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

protected

  def authenticate_inviter!
    (current_user && current_user.admin?) || redirect_to(root_url, :alert => "Sorry, you can't invite new users just yet...")
  end
end
