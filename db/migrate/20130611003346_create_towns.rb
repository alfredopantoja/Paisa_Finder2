class CreateTowns < ActiveRecord::Migration
  def change
    create_table :towns do |t|
      t.string :name
      t.integer :municipality_id

      t.timestamps
    end
		add_index :towns, :municipality_id
  end
end
