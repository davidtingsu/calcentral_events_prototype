class Categorization < ActiveRecord::Base
  attr_accessible :category_id, :club_id
  belongs_to :category
  belongs_to :club
end
