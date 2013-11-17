

class Event < ActiveRecord::Base 
  #http://guides.rubyonrails.org/active_record_querying.html#passing-in-arguments
  scope :find_by_category, ->(*categories){ includes(:club => :categories).where("categories.name IN (:names)", :names => categories)}
  scope :find_by_club, ->(*clubs){ includes(:club).where("clubs.name IN (:names) ", :names => clubs)}

  scope :chronological_order, order("start_time ASC")
  scope :reverse_chronological_order, order("start_time DESC")
  attr_accessible :description, :end_time, :name, :start_time, :facebook_id
  belongs_to :club
  has_many :categories, :through => :club, :source => :categories	
  def self.get_facebook_group_events(graph_id, user_access_token)
    MiniFB.get(user_access_token, graph_id , :type => "events")
  end



  @@access_token = "173006739573053|DPlwPfobC-caWfyYKw5rU-aKrjM"


  def self.getFacebookEvents(facebook_page_id)
     MiniFB.fql(@@access_token,"SELECT eid, name, location, description, start_time, end_time, timezone FROM event where creator = #{CGI.escape(facebook_page_id)}") if facebook_page_id.present?
  end



  def self.facebookIDFromFacebookPageUrl(url)
    url = "https://graph.facebook.com/?ids=#{url}"
    response_page = HTTParty.get(url)
    return response_page.parsed_response[response_page.keys[0]]['id']
  end

     
end 


