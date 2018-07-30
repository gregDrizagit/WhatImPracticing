class CreateExercises < ActiveRecord::Migration[5.1]
  def change
    create_table :exercises do |t|
      t.text :description
      t.string :name
      t.integer :duration
      t.integer :tempo
      t.string :key
    end
  end
end
