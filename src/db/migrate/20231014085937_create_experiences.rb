class CreateExperiences < ActiveRecord::Migration[7.0]
  def change
    create_table :experiences do |t|
      t.string :title
      t.string :employer
      t.string :description
      t.date :started_at
      t.date :finished_at
      t.boolean :ongoing
      t.references :cv, null: false, foreign_key: true

      t.timestamps
    end
  end
end
