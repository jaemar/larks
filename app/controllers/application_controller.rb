class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to "/", alert: exception.message
  end


  def after_sign_in_path_for(resource_or_scope)
    if request.env['omniauth.origin']
      thank_you_path
    else
      info_startups_path
    end
  end

  def facebook_cookies
    @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
  end
end
