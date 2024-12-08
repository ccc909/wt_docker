class JobLocation < ApplicationRecord
  belongs_to :job
  belongs_to :location
end
