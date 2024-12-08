class JobController < ApplicationController
  before_action :check_company, except: [:destroy]
  before_action :check_company_permission, except: [:destroy]
  before_action :set_jobs

  def render_create
    @available_skills = Skill.all
    @available_locations = Location.all.order(city: :asc)
    @new_job = Job.new
    respond_to do |f|
      f.js
    end
  end 
  
  def index 
    @available_skills = Skill.all
    @new_job = Job.new
  end

  def add_skills(job)
    if job.user_id == current_user.id
      current_user.jobs.find(job.id).skills.destroy_all

      selected_skill_ids = params[:job][:skill_ids]
      return unless selected_skill_ids.present?

      selected_skills = Skill.where(id: selected_skill_ids)
      job.skills << selected_skills
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def add_locations(job)
    if job.user_id == current_user.id
      current_user.jobs.find(job.id).locations.destroy_all

      selected_location_ids = params[:job][:location_ids]
      return unless selected_location_ids.present?

      selected_locations = Location.where(id: selected_location_ids)
      job.locations << selected_locations
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def create 
    @job = current_user.jobs.build(title: params[:job][:title], description: params[:job][:description])
    respond_to do |format|
      if @job.save
        add_skills(@job)
        add_locations(@job)
        format.json { render json: { message: "Job Posted!"} }
        format.js 
      else
        format.json { render json: { message: "Something went wrong"} }
      end
    end
  end

  def edit
    @available_skills = Skill.all
    @available_locations = Location.all.order(city: :asc)
    @job = current_user.jobs.find(params[:id])
    respond_to do |f|
      f.js
    end
  end

  def update
    @job = Job.find(params[:id])
    if @job.user_id == current_user.id
      if @job.update(title: params[:job][:title], description: params[:job][:description])
        add_skills(@job)
        add_locations(@job)
        respond_to do |format|
          format.json { render json: {message: "Job Posted!"} }
          format.js
        end
      else
        respond_to do |format|
          format.json { render json: {message: "Something went wrong"} }
        end
      end
    end
  end

  def destroy 
    @job = Job.find(params[:id])
    if @job.user_id == current_user.id || is_admin?(current_user.id)
      respond_to do |format|
        if @job.destroy
          format.json { render json: {message: "Job deleted!"} }
          format.js
          format.html { redirect_back(fallback_location: root_path) }
        else
          format.json { render json: {message: "Something went wrong"} }
          format.html { redirect_back(fallback_location: root_path) }
        end
      end
    end
  end

  def view_applications
    @job = Job.find(params[:id])
    @back = params[:back] || false
    @liked = params[:liked] || false
    respond_to do |f|
      f.js
    end
  end

  def view_application_details
    @app = Application.find(params[:id])
    
    if @app.viewed == false
      @app.update(viewed: true)
      UserMailer.send_application_status(@app).deliver_later
    end

    respond_to do |f|
      f.js
    end
  end

  def like_cv
    @app = Application.find(params[:id])
    liked = !@app.liked
    @app.update(liked: liked)
  end

private

  def job_params
    params.require(:job).permit(:title, :description, :skill_ids[], :location_ids[])
  end

  def set_jobs
    @jobs = current_user.jobs.all.order(created_at: :desc)
  end
end
