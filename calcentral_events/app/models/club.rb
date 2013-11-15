class Club < ActiveRecord::Base
  belongs_to :category
  attr_accessible :description, :facebook_id, :name
end
