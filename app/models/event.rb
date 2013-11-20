class Event < ActiveRecord::Base 
  #http://guides.rubyonrails.org/active_record_querying.html#passing-in-arguments
  scope :find_by_category, ->(*categories){ includes(:club => :categories).where("categories.name IN (:names)", :names => categories)}
  scope :find_by_club, ->(*clubs){ includes(:club).where("clubs.name IN (:names) ", :names => clubs)}

  scope :chronological_order, order("start_time ASC")
  scope :reverse_chronological_order, order("start_time DESC")
  attr_accessible :description, :end_time, :name, :start_time, :facebook_id, :callink_id
  belongs_to :club
  has_many :categories, :through => :club, :source => :categories	
  def self.get_facebook_group_events(graph_id, user_access_token)
    MiniFB.get(user_access_token, graph_id , :type => "events")
  end

  @@access_token = "173006739573053|DPlwPfobC-caWfyYKw5rU-aKrjM"
  @@daysRegex = /Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday|every day|every|&/
  @@monthRegex = /(January|February|March|April|May|June|July|August|September|October|November|December) \d{1,2} \d{4}|(January|February|March|April|May|June|July|August|September|October|November|December) \d{1,2}|\d{1,2} \d{4}|(January|February|March|April|May|June|July|August|September|October|November|December) \d{1,2}/

  def self.getFacebookEvents(facebook_page_id)
     MiniFB.fql(@@access_token,"SELECT eid, name, location, description, start_time, end_time, timezone FROM event where creator = #{CGI.escape(facebook_page_id)}") if facebook_page_id.present?
  end



  def self.facebookIDFromFacebookPageUrl(url)
    url = "https://graph.facebook.com/?ids=#{url}"
    response_page = HTTParty.get(url)
    return response_page.parsed_response[response_page.keys[0]]['id']
  end

  def self.saveCallinkEvents
    self.getCallinkEvents.each{ |event_hash|
        event = Event.find_by_callink_id(event_hash[:id])
        hash = {}
        %w(description name).map(&:to_sym).each{ |symbol|
            hash[symbol] = event_hash[symbol] if event_hash[symbol].present?
        }
        hash[:callink_id] = event_hash[:id] if event_hash[:id].present?
        if event.present?
            event.update_attributes!(hash)
        else
            event = Event.create!(hash)
        end
        if event_hash[:start_time].present? and event_hash[:start_date].present?
            d = Time.parse(event_hash[:start_date])
            t = Time.parse(event_hash[:start_time])
            dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)
            event.update_attribute(:start_time, dt)
        else
            event.update_attribute(:start_time, event_hash[:start_datetime])
        end
        end_dt = Time.parse(event_hash[:end_time])
        if /^\d{2}:\d{2}:\d{2}$/.match(event_hash[:end_time])
            end_dt = DateTime.new(event.start_time.year, event.start_time.month, event.start_time.day, end_dt.hour, end_dt.min, end_dt.sec)
            event.update_attribute(:end_time, end_dt)
        else
            event.update_attribute(:end_time, end_dt)
        end
    }
  end

  def self.getCallinkEvents
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

  public
  def self.makeUriForXml    
    return "http://events.berkeley.edu/index.php/rss/sn/pubaff/type/day/tab/all_events.html"
  end

  def self.makeXmlDoc(uri)
    if uri != "http://events.berkeley.edu/index.php/rss/sn/pubaff/type/day/tab/all_events.html"
        return ""
    end
    
    xml = URI.parse(uri).read
    return Nokogiri::XML(xml) #return doc
  end

  def self.savingEventsBerkeley(doc, dateTimeTable)
 
    allSavedEvents = []
    doc.xpath('//item').each do |item|
      
      name = (item/'./title').text.to_s.split(",")[0]
      description = ActionView::Base.full_sanitizer.sanitize((item/'./description').text)
      event_id = /\d{5}/.match((item/'./link').text)[0]
      
      start_time = dateTimeTable[event_id][0]
      end_time = dateTimeTable[event_id][1] 
      
      
      newEvent = Event.create!(:name => name, :description => description, :facebook_id => event_id, :start_time => start_time, :end_time => end_time)
      allSavedEvents.push(newEvent)
     
    end

    return allSavedEvents
  end


  def self.parsingHtmlAndReturnDateTimes
    
    doc = Nokogiri::HTML(open("http://events.berkeley.edu/index.php/html/sn/pubaff/type/day/tab/all_events.html"))
  
    dateTimeTable = {}
   
    
    doc.css("div.event").map do |eventNode|
      dates = []
      endDate, endTime = nil, nil
      link = eventNode.at_css("h3 a")['href']
      eventID = /\d{5}/.match(link)[0]
      dateTime = eventNode.at_css('p').text.gsub(/\s/, '')
      days = dateTime.gsub(/\W/, " ").scan(@@daysRegex).join(" ")
  
      startTime = dateTime.split("|")[2].split("-")[0]
      if (dateTime.split("|")[2].split("-").size != 1)
        endTime = dateTime.split("|")[2].split("-")[1]
      end
      
      matching = @@monthRegex.match(dateTime.gsub(/\W/, " "))
      startDate = matching[0]
     
      if (@@monthRegex.match(matching.post_match) != nil)
        endDate = @@monthRegex.match(matching.post_match)[0]
      end
      start = startDate + " " + startTime + " " + days
     
      if (endDate != nil && endTime != nil)
        ending = endDate + " " + endTime
      end
      ending = endTime
      dateTimeTable[eventID] = dates.push(start,ending)

    end
    return dateTimeTable
  end
  
end 


