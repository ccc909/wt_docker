class CreateEducations < ActiveRecord::Migration[7.0]
  def change
    create_table :educations do |t|
      t.string :institution
      t.string :specialization
      t.string :degree
      t.date :started_at
      t.date :finished_at
      t.boolean :ongoing
      t.references :cv, null: false, foreign_key: true

      t.timestamps
    end
  end
end
