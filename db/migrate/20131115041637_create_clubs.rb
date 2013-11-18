class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.text :description
      t.text :name
      t.string :facebook_id
      t.references :category

      t.timestamps
    end
    add_index :clubs, :category_id
  end
end
