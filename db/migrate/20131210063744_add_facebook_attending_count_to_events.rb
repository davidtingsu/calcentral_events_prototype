class AddFacebookAttendingCountToEvents < ActiveRecord::Migration
  def change
    add_column :events, :facebook_attending_count, :integer
  end
end
