class CreateMunicipalities < ActiveRecord::Migration
  def change
    create_table :municipalities do |t|
      t.string :name
      t.integer :state_id

      t.timestamps
    end
		add_index :municipalities, :state_id
  end
end
