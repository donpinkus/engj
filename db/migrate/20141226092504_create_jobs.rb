class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :angel_id
      t.string :title
      t.text :description
      t.string :listing_created_at
      t.datetime :listing_updated_at
      t.float :equity_min
      t.float :equity_max
      t.string :currency_code
      t.string :job_type
      t.integer :salary_min
      t.integer :salary_max
      t.string :angellist_url
      t.string :location
      t.string :role
      t.string :company_name
      t.integer :company_id
      t.string :logo_url
      t.text :product_desc
      t.text :high_concept
      t.string :company_url
      t.integer :page_id

      t.timestamps
    end
  end
end
