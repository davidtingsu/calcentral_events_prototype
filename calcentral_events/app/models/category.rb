class Category < ActiveRecord::Base
  belongs_to :club
  attr_accessible :name
end
