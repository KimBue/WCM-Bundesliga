class CreateLeagueGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :league_goals do |t|
      t.integer :league_id
      t.string :goal_id

      t.timestamps
    end
  end
end
