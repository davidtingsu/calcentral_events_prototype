class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.references :club

      t.timestamps
    end
    add_index :categories, :club_id
  end
end
