class CreateLeagues < ActiveRecord::Migration[5.1]
  def change
    create_table :leagues, id: false do |t|
      t.integer :league_id, null: false
      t.string :league_name
      t.string :league_shortcut
      t.integer :sports_id
      t.string :sports_name

      t.timestamps
    end
    add_index :leagues, :league_id, unique: true
  end
end
