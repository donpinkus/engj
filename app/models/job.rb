class Job < ActiveRecord::Base
  belongs_to :company, foreign_key: "angel_id"
  has_many :job_skills

  validates_uniqueness_of :angel_id
  validates :currency_code, length: { maximum: 255 }
  validates :job_type, length: { maximum: 255 }
  validates :location, length: { maximum: 255 }
  validates :role, length: { maximum: 255 }
end
