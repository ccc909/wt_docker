class HomeController < ApplicationController
  #before_action :check admin!!!!!!

  def feed
    @locations = Location.all.order(city: :asc)
    
    @jobs = Job.where(user: {blocked: false}).includes(:skills, user: { company_information: :company_picture_blob }).order(created_at: :desc)

    @jobs = @jobs.joins(user: :company_information).where("lower(title) LIKE :search OR lower(company_informations.name) LIKE :search", search: "%#{params[:title].downcase}%") if params[:title].present?

    @jobs = @jobs.joins(:locations).where(locations: { city: params[:filter_city] }) if params[:filter_city].present?
    
    @jobs = @jobs.sort_by { |job| - (matching_percentage(job)).to_f } if user_signed_in?
    
    @jobs = Kaminari.paginate_array(@jobs).page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.js
    end
    
  end
  

  def view_job
    @job = Job.find(params[:id])
    respond_to do |f|
      f.js
    end
  end

end