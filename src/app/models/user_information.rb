class UserInformation < ApplicationRecord
  belongs_to :user

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: true
  validates :birthdate, presence: true
  validates :sex, presence: true
  validates :phone_number, presence: true
  validates :birthdate, presence: true
  validate :birthdate_in_the_past
  
  private
  def birthdate_in_the_past
    if birthdate.present? && birthdate > Date.current
      errors.add(:birthdate, 'must not be in the future')
    end
  end

end
