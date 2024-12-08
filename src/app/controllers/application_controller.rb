class ApplicationController < ActionController::Base
  include ApplicationHelper
  include CompanyHelper
  include CvHelper
  include FeedHelper
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_blocked_user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:company, :deployed])
    devise_parameter_sanitizer.permit(:account_update, keys: [:company, :deployed, :admin])
  end

end
