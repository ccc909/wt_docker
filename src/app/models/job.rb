class Job < ApplicationRecord
  belongs_to :user
  has_many :job_skills, dependent: :destroy
  has_many :skills, through: :job_skills
  has_many :applications, dependent: :destroy
  has_many :cvs, through: :applications
  has_many :job_location, dependent: :destroy
  has_many :locations, through: :job_location
end
