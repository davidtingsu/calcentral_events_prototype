class Event < ActiveRecord::Base
  belongs_to :club
  attr_accessible :description, :end_time, :facebook_id, :start_time
end
