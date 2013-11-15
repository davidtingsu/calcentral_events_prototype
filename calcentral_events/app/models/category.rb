class Category < ActiveRecord::Base
  has_many :clubs
  attr_accessible :name
end
