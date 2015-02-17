class Company < ActiveRecord::Base
  has_many :jobs
  has_many :job_skills, through: :jobs

  has_many :angel_taggings, :as => :angel_taggable
end
