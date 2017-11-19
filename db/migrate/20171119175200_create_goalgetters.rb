class CreateGoalgetters < ActiveRecord::Migration[5.1]
  def change
    create_table :goalgetters do |t|
      t.integer :goalgetter_id
      t.string :name
      t.string :wikidata_id
      t.integer :birthplace_id
      t.integer :team_id

      t.timestamps
    end
  end
end
