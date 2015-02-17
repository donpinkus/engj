class CreateAngelTaggings < ActiveRecord::Migration
  def change
    create_table :angel_taggings, id: false do |t|
      t.references :angel_tag
      t.references :angel_taggable, polymorphic: true

      t.timestamps
    end
  end
end
