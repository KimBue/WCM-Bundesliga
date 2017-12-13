class CreateBirthplaces < ActiveRecord::Migration[5.1]
  def change
    create_table :birthplaces do |t|
      t.string :name
      t.string :wiki_id
      t.string :district_wiki_id
      t.integer :population

      t.timestamps
    end
  end
end
