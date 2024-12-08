class AdminController < ApplicationController
  before_action :check_admin

  def search
    search_term = params[:search]
    @users = User.where.not(id: current_user.id).order(:email).includes(:user_information, :company_information)
    @users = @users.where.not(company: true, enabled: false)
    @users = @users.joins("LEFT JOIN user_informations ON users.id = user_informations.user_id")
            .joins("LEFT JOIN company_informations ON users.id = company_informations.user_id")
            .where("user_informations.first_name ILIKE :search_term OR user_informations.last_name ILIKE :search_term OR company_informations.name ILIKE :search_term OR email ILIKE :search_term", search_term: "%#{search_term}%")
            .includes(:company_information, :user_information)
            .page(params[:page])
            .per(10)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def index
    @users = User.where.not(id: current_user.id).order(:email).includes(:user_information, :company_information)
    @users = @users.where("company = ? OR enabled = ?", false, true)
    
    @user_page = params[:user_page]
    
    @users = Kaminari.paginate_array(@users).page(params[:user_page]).per(5)

    @companies = User.where(company: true, enabled: false)

    @company_page = params[:company_page]
    @companies = Kaminari.paginate_array(@companies).page(params[:company_page]).per(5)

    respond_to do |format|
      format.html 
      format.js  
    end
  end

  def enable_company
    @user = CompanyInformation.find(params[:id]).user
    value = !@user.enabled
    @user.update(enabled: value)

    CompanyMailer.send_status_update(@user).deliver_now
  end

  def add_verification_status
    @information = CompanyInformation.find(params[:id])
    @information.update(status: params[:company_information][:status])
    @information.user.update(enabled: false)

    CompanyMailer.send_status_update(@user).deliver_now
  end

  def show_company_information
    @company_information = User.find(params[:id]).company_information
    @id = params[:id]
    respond_to do |f|
      f.js 
    end
  end
  
  def block_user
    @user = User.find(params[:id])
    value = !@user.blocked
    respond_to do |f|
      if @user.update(blocked: value)
        f.json { render json: { message: "Success"} }
      else
        f.json { render json: { message: "Error" } }
      end
    end
  end

  def update_admin
    @user = User.find(params[:id])
    value = !@user.admin
    respond_to do |f|
      if @user.update(admin: value)
        f.json { render json: { message: "Success"} }
      else
        f.json { render json: { message: "Error" } }
      end
    end
  end

end