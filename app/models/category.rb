class Category < ActiveRecord::Base
  attr_accessible :name, :callink_id
  has_many :clubs
end
