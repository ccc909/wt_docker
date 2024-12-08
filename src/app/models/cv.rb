class Cv < ApplicationRecord
  belongs_to :user
  has_many :educations, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :cv_skills, dependent: :destroy
  has_many :skills, through: :cv_skills
  has_many_attached :pdfs, dependent: :destroy
  has_one_attached :picture, dependent: :destroy
  has_many :applications, dependent: :destroy
  has_many :jobs, through: :applications

  before_destroy :clear_cv_associated

  private

  def clear_cv_associated
    self.jobs.clear
    self.skills.clear
    self.educations.destroy_all
    self.experiences.destroy_all
  end

end
