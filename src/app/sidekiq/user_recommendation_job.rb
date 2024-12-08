require 'sidekiq-scheduler'
include FeedHelper

class UserRecommendationJob
  include Sidekiq::Job

  def perform(*args)
    @users = User.where(company: false, admin: false)
    @jobs = Job.includes(:skills).order(created_at: :desc)
    @users.each do |user|
      jobs = @jobs.sort_by { |job| - (matching_by(job,user.cvs.first)).to_f }.first(4)
      UserMailer.send_job_recommendation(user, jobs).deliver_now
      #puts "sent message to #{user.email} with jobs #{jobs.map { |job| job.title } }"
    end
  end

end
