class FixTypesInTables < ActiveRecord::Migration
  def up
    change_column :jobs, :title, :text
    change_column :jobs, :salary_min, :bigint, :limit => 8
    change_column :jobs, :salary_max, :bigint, :limit => 8
    change_column :job_skills, :name, :text
  end

  def down
    change_column :jobs, :title, :string
    change_column :jobs, :salary_min, :bigint, :limit => 4
    change_column :jobs, :salary_max, :bigint, :limit => 4
    change_column :job_skills, :name, :string
  end
end
