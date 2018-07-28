class CreateSessionsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.text :description
      t.string :name
      t.integer :duration
      t.integer :tempo
      t.string :key
      t.timestamps
    end
  end
end
