class AddFacebookPicSquareToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_pic_square, :string
  end
end
