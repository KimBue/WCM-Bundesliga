class CreateMatchResults < ActiveRecord::Migration[5.1]
  def change
    create_table :match_results, id: false do |t|
      t.integer :result_id, null: false
      t.string :result_name
      t.integer :points_team1
      t.integer :points_team2
      t.integer :result_order_id
      t.integer :result_type_id
      t.text :result_description
      t.integer :match_id

      t.timestamps
    end
    add_index :match_results, :result_id, unique: true
    add_index :match_results, :match_id
  end
end
