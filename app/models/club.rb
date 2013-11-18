class Club < ActiveRecord::Base
  attr_accessible :description, :name, :facebook_id, :facebook_url
  has_many :events 
  has_many :categories
  def get_facebook_group_events(user_access_token)
    MiniFB.get(user_access_token, facebook_id , :type => "events") if (facebook_id and user_access_token != " ")
  end

end
