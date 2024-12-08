class CreateUserInformations < ActiveRecord::Migration[7.0]
  def change
    create_table :user_informations do |t|
      t.string :first_name
      t.string :last_name
      t.string :country
      t.string :county
      t.string :city
      t.string :address
      t.date :birthdate
      t.string :sex
      t.string :phone_number
      t.references :user, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
