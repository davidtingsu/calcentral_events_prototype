class Category < ActiveRecord::Base
  attr_accessible :name, :callink_id
  has_many :categorizations
  has_many :clubs, :through => :categorizations
end
