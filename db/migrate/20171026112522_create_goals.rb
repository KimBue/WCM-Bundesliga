class CreateGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :goals, id: false do |t|
      t.integer :goal_id, null: false
      t.integer :goal_getter_id
      t.string :goal_getter_name
      t.boolean :is_overtime
      t.boolean :is_own_goal
      t.boolean :is_penalty
      t.integer :match_minute
      t.integer :score_team1
      t.integer :score_team2
      t.text :comment
      t.integer :match_id

      t.timestamps
    end
    add_index :goals, :goal_id, unique: true
    add_index :goals, :match_id
  end
end
