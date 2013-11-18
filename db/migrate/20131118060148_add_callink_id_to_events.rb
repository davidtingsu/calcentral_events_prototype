class AddCallinkIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :callink_id, :string
  end
end
