class UserInformationController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user

  def update
    @user_information = current_user.user_information
    respond_to do |f|
      if @user_information.update(user_information_params)
        f.json { render json: {message: "Saved."}}
      else
        f.json { render json: {message: "Something went wrong!"}}
      end
    end
  end

  def create
    user = User.find(current_user.id)
    @user_information = user.build_user_information(user_information_params)
    respond_to do |f|
      if @user_information.save
        f.js
        f.json { render json: {message: "Saved."}}
      else
        f.json { render json: {message: "Something went wrong!"}}
      end
    end
  end

  def destroy
    account_information = current_user.user_information
  
    if account_information
      account_information.destroy
      return
    else
      return
    end
  
    #redirect_to users_path
  end
  
  
private

  def user_information_params
    params.require(:user_information).permit(:first_name, :last_name, :address, :birthdate, :sex, :phone_number, :country, :county, :city)
  end


end