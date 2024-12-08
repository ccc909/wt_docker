class CompanyInformationController < ApplicationController
  before_action :authenticate_user!
  before_action :check_company

  def update
    @company_information = current_user.company_information
    respond_to do |f|
      if @company_information.update(company_information_params)
        @company_information.update(status: "Pending verification")
        f.json { render json: {message: "Saved."}}
      else
        f.json { render json: {message: "Something went wrong!"}}
      end
    end
  end

  def create
    user = User.find(current_user.id)
    @company_information = user.build_company_information(company_information_params)
    respond_to do |f|
      if @company_information.save
        f.js
        f.json { render json: {message: "Saved."}}
      else
        f.json { render json: {message: "Something went wrong!"}}
      end
    end
  end

  def add_picture
    company_information = current_user.company_information
    if params[:company_information].present? && params[:company_information][:company_picture].present?
      if company_information && company_information.company_picture.present?
        company_information.company_picture.delete
      end
      company_information.company_picture.attach(params[:company_information][:company_picture])
      flash[:success] = "Picture uploaded"
      redirect_to profile_index_path
    end
  end

  def delete_picture
    if current_user.company_information.present? && current_user.company_information.company_picture.present?
      if current_user.company_information.company_picture.delete
        flash[:success] = "Succesfully deleted picture."
      else
        flash[:error] = "Something went wrong."
      end
    end
    redirect_to profile_index_path
  end

  def destroy
    company_information = current_user.company_information
  
    if company_information
      company_information.destroy
      return
    else
      return
    end
  
    #redirect_to users_path
  end
  
  
private

  def company_information_params
    params.require(:company_information).permit(:address,:phone_number,:country, :name)
  end


end