class ChangeCompanyIdToCompanyAngelId < ActiveRecord::Migration
  def change
    rename_column :jobs, :company_id, :company_angel_id
  end
end
