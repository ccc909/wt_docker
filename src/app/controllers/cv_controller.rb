class CvController < ApplicationController
  before_action :check_user
  before_action :set_cv, except: [:index, :new, :create, :configure_cv, :destroy, :add_skills]

  def index
    @cv = current_user.cvs.all.includes(:skills, :education, :experience)
    @new_cv = Cv.new
  end

  def new
    @new_cv = Cv.new
  end

  def create
    user = User.find(current_user.id)
    @cv = user.cvs.create(cv_params)
    if @cv.save
      redirect_to configure_cv_cv_path(@cv.id)
    else
      flash[:error] = "Something went wrong!"
      redirect_to landing_path
    end
  end

  def configure_cv
    @index = 0
    @available_skills = Skill.all
    @cv = Cv.includes(:skills).find(params[:id])
    @education = Education.new
    @experience = Experience.new
    @skill = Skill.new
  end

  def create_education

    unless check_date_validation(params[:education][:started_at],params[:education][:finished_at])
      render json: { message: "Finish date cannot be earlier than start date" }, status: :unprocessable_entity
      return
    end

    @education = @cv.educations.create(education_params)

    respond_to do |format|
      if @education.save
        format.json { render json: { message: "Added successfully!" } }
        format.js
      else
        format.json { render json: { message: "Something went wrong!" }, status: :unprocessable_entity }
      end
    end
  end

  def update_education
    education = @cv.educations.find(params[:id])
  
    if education.update(education_params)
      render json: { message: "Education updated." }
    else
      render json: { message: "Failed to update education." }
    end
  end

  def create_experience
    unless check_date_validation(params[:experience][:started_at], params[:experience][:finished_at])
      render json: { message: "Finish date cannot be earlier than start date" }, status: :unprocessable_entity
      return
    end
  
    @experience = @cv.experiences.create(experience_params)
  
    respond_to do |format|
      if @experience.save
        format.json { render json: { message: "Added successfully!" } }
        format.js
      else
        format.json { render json: { message: "Something went wrong!" }, status: :unprocessable_entity }
      end
    end
  end
  
  def update_experience
    experience = @cv.experiences.find(params[:id])
  
    if experience.update(experience_params)
      render json: { message: "Experience updated." }
      return
    else
      render json: { message: "Failed to update experience." }
      return
    end
  end

  def add_skills
    @cv = Cv.find(params[:id])
    @cv.skills.destroy_all

    selected_skill_ids = params[:skill_ids]
  
    if selected_skill_ids.present?
      selected_skills = Skill.where(id: selected_skill_ids)
  
      @cv.skills << selected_skills
  
      if @cv.save
        render json: { message: "Skills saved." }
        return
      else
        render json: { message: "Failed to save skills." }
        return
      end
    else
      render json: { message: "No skills selected." }
      return
    end
  end
  
  def delete_experience
    @experience = @cv.experiences.find(params[:id])
    if @experience.destroy
      render json: { message: "Delete successful." }
      return
    else
      render json: { message: "Failed to delete experience." }
      return
    end
  end

  def delete_education
    @education = @cv.educations.find(params[:id])
    if @education.destroy
      render json: { message: "Delete successful." }
      return
    else
      render json: { message: "Failed to delete education." }
      return
    end
  end

  def render_form
    @cv = Cv.find(params[:id])
    @education = Education.new
    @experience = Experience.new
    @name = ""
    if params[:education].present?
      @name = "education"
    elsif params[:experience].present?
      @name = "experience"
    end
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def pdf_upload
    if params[:cv][:pdfs].present?
      params[:cv][:pdfs].each do |pdf|
        @cv.pdfs.attach(pdf)
      end
      flash[:success] = "PDFs uploaded successfully."
      redirect_to configure_cv_cv_path(@cv.id)
    else
      flash[:error] = "No PDFs selected for upload."
      redirect_to configure_cv_cv_path(@cv.id)
    end
  end  

  def delete_pdf
    if params[:id].present?
      @cv.pdfs.find(params[:id]).destroy
      render json: { message: "PDF deleted." }
    else
      render json: { message: "Something went wrong." }
    end
  end

  def upload_picture
    if params[:cv].present? && params[:cv][:picture].present?
      @cv.picture.destroy
      @cv.picture.attach(params[:cv][:picture])
      flash[:success] = "Picture uploaded."
      redirect_to configure_cv_cv_path(@cv.id)
    else
      flash[:error] = "Upload failed."
      redirect_to configure_cv_cv_path(@cv.id)
    end
  end

  def delete_picture
    if @cv.picture
      @cv.picture.destroy
      render json: { message: "Image deleted." }
    else
      render json: { message: "Something went wrong." }
    end
  end

  def destroy

    cv = Cv.find(params[:id])
    if cv.user_id == current_user.id
      respond_to do |format|
        if cv.destroy
          @cvs = current_user.cvs.all
          format.js
          format.html { redirect_to profile_index_path }
        else
          format.html { redirect_to profile_index_path, alert: "Failed to delete the CV." }
        end
      end
    else
      redirect_back(fallback_location: root_path)
    end
  end
  
  private

  def set_cv
    if Cv.find(params[:cv_id]).user_id == current_user.id
      @cv = current_user.cvs.find(params[:cv_id])
    else
      redirect_to cv_index_path
    end
  end
  
  def cv_params
    params.require(:cv).permit(:title, { skill_ids: [] })
  end  
  
  def education_params
    params.require(:education).permit(:institution, :specialization, :degree, :started_at, :finished_at, :ongoing)
  end
  
  def experience_params
    params.require(:experience).permit(:title, :employer, :description, :started_at, :finished_at, :ongoing)
  end
  
  end
  
