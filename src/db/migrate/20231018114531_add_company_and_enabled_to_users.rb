class AddCompanyAndEnabledToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :company, :boolean, default: false
    add_column :users, :enabled, :boolean, default: false
  end
end
