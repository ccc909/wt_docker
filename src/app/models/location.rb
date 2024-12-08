class Location < ApplicationRecord
  has_many :job_location, dependent: :destroy
  has_many :jobs, through: :job_location
end
