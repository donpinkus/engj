class Job < ActiveRecord::Base
  validates_uniqueness_of :angel_id
  has_many :job_skills
end
