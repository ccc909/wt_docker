class Skill < ApplicationRecord
  has_many :cv_skills, dependent: :destroy
  has_many :cvs, through: :cv_skills
  has_many :job_skills, dependent: :destroy
  has_many :jobs, through: :job_skills
  before_destroy :clear_associated_jobs_and_cvs

  def clear_associated_jobs_and_cvs
    Job.joins(:skills).where('skills.id = ?', self.id).delete_all
    Cv.joins(:skills).where('skills.id = ?', self.id).delete_all
    CvSkill.where(skill_id: self.id).delete_all
    JobSkill.where(skill_id: self.id).delete_all
  end

end
