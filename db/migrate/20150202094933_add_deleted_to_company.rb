class AddDeletedToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :deleted, :boolean
  end
end
