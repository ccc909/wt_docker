class CompanyMailer < ApplicationMailer

  def send_job_applications(user, jobs)
    @user = user
    @jobs = jobs
    mail(to: @user.email, subject: 'These jobs are the best matches!')
  end

  def send_status_update(company)
    @company = company
    mail(to: company.email, subject: 'Your account has been reviewed')
  end

end
