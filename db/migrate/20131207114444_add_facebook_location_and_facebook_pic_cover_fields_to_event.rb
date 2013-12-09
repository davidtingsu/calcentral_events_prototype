class AddFacebookLocationAndFacebookPicCoverFieldsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :facebook_pic_cover, :string
    add_column :events, :location, :string
  end
end
