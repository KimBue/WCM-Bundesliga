class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams, id: false do |t|
      t.integer :team_id, null: false
      t.string :team_name
      t.string :short_name
      t.string :team_icon_url

      t.timestamps
    end
    add_index :teams, :team_id, unique: true
  end
end
