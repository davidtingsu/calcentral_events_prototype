class AddCallinkIdToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :callink_id, :string
    add_index :categories, :callink_id
  end
end
