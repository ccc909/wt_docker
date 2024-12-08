class AddLikedToApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :applications, :liked, :boolean, default: false
  end
end
