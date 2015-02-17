class CreateAngelTags < ActiveRecord::Migration
  def change
    create_table :angel_tags, id: false do |t|
      t.primary_key :angel_id
      t.string :tag_type
      t.text :name
      t.text :display_name
      t.text :angellist_url

      t.timestamps
    end
  end
end
