require 'sidekiq-scheduler'

class CompanyJobApplications
  include Sidekiq::Job

  def perform(*args)
    @companies = User.where(company: true)
    @jobs = Job.includes(:skills).order(created_at: :desc)
    @companies.each do |company|
      count = 0
      jobs = @jobs.where(user_id: company.id).first(4)
      count += jobs.map { |job| job.applications.present? }.count
      CompanyMailer.send_job_applications(company, jobs).deliver_now if count > 0
      #puts "sent message to #{company.email} with applications #{jobs.map { |job| job&.applications.all.map { |app| app.cv_id }.to_s }.to_s }"
    end
  end

end
