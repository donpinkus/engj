class CreateJobSkills < ActiveRecord::Migration
  def change
    create_table :job_skills do |t|
      t.references :job, index: true
      t.string :name
      t.integer :angel_id

      t.timestamps
    end
  end
end
