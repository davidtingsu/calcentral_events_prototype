class AddFacebookUrlToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :facebook_url, :string
  end
end
