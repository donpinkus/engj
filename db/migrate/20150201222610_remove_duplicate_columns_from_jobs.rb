class RemoveDuplicateColumnsFromJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :logo_url
    remove_column :jobs, :product_desc
    remove_column :jobs, :high_concept
    remove_column :jobs, :company_url
    remove_column :jobs, :company_name
  end

  def down
    add_column :jobs, :logo_url, :string
    add_column :jobs, :product_desc, :text
    add_column :jobs, :high_concept, :text
    add_column :jobs, :company_url, :string
    add_column :jobs, :company_name, :string
  end
end
