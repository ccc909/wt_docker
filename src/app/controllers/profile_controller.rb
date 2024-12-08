class ProfileController < ApplicationController
  before_action :authenticate_user!, except: [:view_company]
  before_action :check_user, only: [:apply_to_job]

  def index

    if is_company?(current_user.id)
      if current_user.company_information.present?
        @company_information = current_user.company_information
      else
        @company_information = CompanyInformation.new
      end
      
    else
      @applications = Application.where(cv_id: current_user.cvs.pluck(:id)).includes(:cv, :job).order(created_at: :desc)
      @applications = Kaminari.paginate_array(@applications).page(params[:page]).per(2)

      @cvs = current_user.cvs.all
      @new_cv = Cv.new

      if current_user.user_information.present?
        @user_information = current_user.user_information
      else
        @user_information = UserInformation.new
      end
    end
    
    respond_to do |format|
      format.html
      format.js
    end

  end
  
  def apply_to_job
    cv = Cv.find(params[:cv_id])
    
    unless cv.user.id == current_user.id
      return
    end

    unless current_user.user_information.present?
      return
    end

    user = User.find(cv.user.id) #if any cvs were used to apply to this job, block another application from same user
    user.cvs.each do |cv|
      if Application.find_by(cv_id: cv.id, job_id: params[:job_id]).present?
        return
      end
    end

    apply = Application.create(apply_params)
    @job = apply.job
    if apply.save
      @message = "Application sent!"
    else
      @message = "Failed to send application."
    end
    respond_to do |f|
      f.html {redirect_back(fallback_location: root_path)}
      f.js {
        render  :template => "layouts/notice",
                :layout => false
      }
    end
  end

  def view_company
    @company = User.find(params[:id])
    if @company.blocked
      redirect_back(fallback_location: root_path)
      return
    end

    @jobs = @company.jobs.all

    if params[:search].present?
      @jobs = @jobs.where("title ILIKE ?", "%#{params[:search]}%")
    end

    @jobs = Kaminari.paginate_array(@jobs).page(params[:page]).per(3)
    
    respond_to do |f|
      f.html
      f.js
    end
  end

  def cancel_application
    unless Application.find(params[:id]).cv.user.id == current_user.id
      return
    end
    @app = Application.find(params[:id])
    @job = @app.job
    if @app.viewed
      return
    end
    if @app.destroy
      @message = "Application cancelled"
    else
      @message = "Something went wrong."
    end
    respond_to do |f|
      f.html {redirect_back(fallback_location: root_path)}
      f.js {
        render  :template => "layouts/notice",
                :layout => false
      }
    end
  end

private

  def apply_params
    params.permit(:job_id, :cv_id)
  end
end