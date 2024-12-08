class Application < ApplicationRecord
  belongs_to :cv
  belongs_to :job
  attribute :viewed, :boolean, default: false
end
