class CompanyInformation < ApplicationRecord
  belongs_to :user
  has_one_attached :company_picture, dependent: :destroy
end
