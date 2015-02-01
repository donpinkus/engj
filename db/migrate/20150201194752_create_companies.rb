class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.boolean :hidden
      t.boolean :community_profile
      t.string :name
      t.string :angellist_url
      t.string :logo_url
      t.string :thumb_url
      t.integer :quality
      t.text :product_desc
      t.text :high_concept
      t.integer :follower_count
      t.string :company_url
      t.date :created_at
      t.date :updated_at
      t.string :twitter_url
      t.string :blog_url
      t.string :video_url

      t.timestamps
    end
  end
end
