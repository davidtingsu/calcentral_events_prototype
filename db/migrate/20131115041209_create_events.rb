class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :description
      t.string :end_time
      t.string :start_time
      t.string :facebook_id
      t.references :club

      t.timestamps
    end
    add_index :events, :club_id
  end
end
