module CompanyHelper

  def check_company
    if !(user_signed_in? && current_user.company)
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def check_company_permission
    check_company
    if !current_user.enabled 
      flash[:error] = "Account is disabled until document verification!"
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def is_company?(id)
    User.find(id).company
  end

  def is_company_enabled?(id)
    enabled = User.find(id).enabled
    return is_company?(id) && enabled
  end

  def check_user
    unless user_signed_in? && !current_user.company
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def is_user?(id)
    !User.find(id).company
  end

  def display_verified_status(id)
    User.find(id)&.company_information&.status
  end

  def display_company_picture(company)
    if company.company_information.present? && company.company_information.company_picture.present?
      company.company_information.company_picture
    else
      "https://img.freepik.com/premium-vector/briefcase-isolated-background-vector-illustration-flat-design-attache-case-diplomat-is-accessory-business-people_153097-721.jpg"
    end
  end

end
