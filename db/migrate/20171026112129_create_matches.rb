class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches, id: false do |t|
      t.integer :match_id, null: false
      t.datetime :match_date_time
      t.datetime :match_date_time_utc
      t.datetime :last_update_date_time
      t.boolean :match_is_finished
      t.integer :location_id
      t.string :location_city
      t.string :location_stadium
      t.integer :number_of_viewers
      t.string :time_zone_id
      t.integer :group_id
      t.integer :league_id
      t.integer :team1_id
      t.integer :team2_id

      t.timestamps
    end
    add_index :matches, :match_id, unique: true
    add_index :matches, :group_id
    add_index :matches, :league_id
  end
end
