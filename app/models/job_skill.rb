class JobSkill < ActiveRecord::Base
  validates_uniqueness_of :angel_id
  belongs_to :job
end
