class AddSessionColumnToExercises < ActiveRecord::Migration[5.1]
  def change
    add_column :exercises, :session_id, :integer
  end
end
