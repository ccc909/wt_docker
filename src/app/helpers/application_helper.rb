module ApplicationHelper

  def check_admin
    unless user_signed_in? && current_user.admin
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def is_admin?(id)
    User.find(id).admin
  end

  def check_blocked_user
    if user_signed_in? && current_user.blocked == "true"
      flash[:error] = "This account is blocked. For more info contact support."
      redirect_to new_user_session_path
      return
    end
  end

end
