class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :town_id

      t.timestamps
    end
    add_index :posts, [:town_id, :created_at]
  end
end
