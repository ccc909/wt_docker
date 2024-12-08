class CreateCompanyInformations < ActiveRecord::Migration[7.0]
  def change
    create_table :company_informations do |t|
      t.string :name
      t.string :country
      t.string :address
      t.string :phone_number


      t.string :status, default: "Pending verification"
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
