class Club < ActiveRecord::Base
  has_many :categories
  has_many :events
  attr_accessible :description, :facebook_id, :name
end
