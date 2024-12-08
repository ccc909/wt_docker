class UserMailer < ApplicationMailer

  def send_job_recommendation(user, jobs)
    @user = user
    @jobs = jobs
    mail(to: @user.email, subject: 'These jobs are the best matches!')
  end

  def send_application_status(app)
    @app = app
    email = @app.cv.user.email
    @job_title = Job.find(app.job_id).title
    @company_name = @app.job.user.company_information.name
    mail(to: email, subject: "Good news! Someone has seen your CV!")
  end

end
