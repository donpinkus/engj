class Company < ActiveRecord::Base
  has_many :jobs
  has_many :job_skills, through: :jobs
end
