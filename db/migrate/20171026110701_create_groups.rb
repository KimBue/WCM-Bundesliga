class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups, id: false do |t|
      t.integer :group_id, null: false
      t.string :group_name
      t.integer :group_order_id

      t.timestamps
    end
    add_index :groups, :group_id, unique: true
  end
end
