class AddCallinkIdAndCallinkPermalinkToClub < ActiveRecord::Migration
  def change
    add_column :clubs, :callink_id, :string
    add_index :clubs, :callink_id
    add_column :clubs, :callink_permalink, :string
    add_index :clubs, :callink_permalink
    add_column :clubs, :permalink, :string
    add_index :clubs, :permalink
  end
end
