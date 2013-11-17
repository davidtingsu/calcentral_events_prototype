

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

  def self.getCallinkEvents()
    events = Nokogiri::XML::Document.parse(HTTParty.get('https://callink.berkeley.edu/EventRss/EventsRss')).xpath('//item')
    results = []
    events.each{ |event|
        hash = self.parse_callink_event(event)
        results << hash
    }
    results
  end

  private
  def self.parse_callink_event(event)
        hash = parse_time_from_description(event.xpath('.//description').inner_text)
        link = event.xpath('.//link').inner_text
        hash.merge({
            title: event.xpath('.//title').inner_text,
            category: event.xpath('.//category').inner_text,
            groupname: (link.scan(/organization\/(.*?)\//).flatten[0] if link.present? && link.scan(/organization\/(.*?)\//).count >= 1 ),
            id: (/details\/(?<id>\d+)/.match(link)['id']   if /details\/(?<id>\d+)/.match(link)),
            link: link,
            description: event.xpath('.//description').inner_text,

        })
  end

  def self.parse_time_from_description(raw_text)
    html=Nokogiri::HTML.parse(CGI.unescapeHTML(raw_text))
    dtstart_1 = html.css('.dtstart .value')
    dtstart_2 = html.css('.dtstart')
    dtend_1 = html.css('.dtend')
    location = html.css('.location')
    {
        start_datetime: (dtstart_2[0]['title'] if dtstart_2.count >=1),
        start_date: (dtstart_1[0]['title'] if dtstart_1.count >= 1),
        start_time:  (dtstart_1[1]['title'] if dtstart_1.count >= 2),

        end_time: (dtend_1[0]['title'] if dtend_1.count >= 1),
        location: (location[0].inner_text if location.count > 0)
    }
  end

     
end 


