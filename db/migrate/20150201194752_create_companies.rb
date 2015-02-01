class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies, id: false do |t|
      t.primary_key :angel_id
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
      t.date :angel_created_at
      t.date :angel_updated_at
      t.string :twitter_url
      t.string :blog_url
      t.string :video_url

      t.timestamps
    end
  end
end
