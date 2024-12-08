class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications do |t|
      t.references :cv, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true
      t.boolean :viewed

      t.timestamps
    end
  end
end
