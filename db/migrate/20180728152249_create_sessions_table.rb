class CreateSessionsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.text :notes
      t.timestamps
    end
  end
end
