# -*- coding: utf-8 -*-


class Event < ActiveRecord::Base 
  #http://guides.rubyonrails.org/active_record_querying.html#passing-in-arguments
  scope :find_by_category, ->(category){ includes(:club => :categories).where("categories.name = ?", category)}
  scope :find_by_club, ->(club){ includes(:club).where("clubs.name = ? ", club)}
  scope :chronological_order, order("start_time ASC")
  scope :reverse_chronological_order, order("start_time DESC")
  attr_accessible :description, :end_time, :name, :start_time, :facebook_id
  belongs_to :club
  has_many :categories, :through => :club, :source => :categories	
  def self.get_facebook_group_events(graph_id, user_access_token)
    MiniFB.get(user_access_token, graph_id , :type => "events")
  end

  @@access_token = "173006739573053|DPlwPfobC-caWfyYKw5rU-aKrjM"
  @@daysRegex = /Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday|every day|every|&/
  @@monthRegex = /(January|February|March|April|May|June|July|August|September|October|November|December) \d{1,2} \d{4}|(January|February|March|April|May|June|July|August|September|October|November|December) \d{1,2}|\d{1,2} \d{4}|(January|February|March|April|May|June|July|August|September|October|November|December) \d{1,2}/

  def self.getFacebookEvents(facebook_page_id)
      #apply for new access_token
   
      #club = (Club.find_by_facebook_id(facebook_page_id) or Club.create!(facebook_id: facebook_page_id))

       MiniFB.fql(@@access_token,"SELECT eid, name, location, description, start_time, end_time, timezone FROM event where creator = #{CGI.escape(facebook_page_id)}") if facebook_page_id.present?
     
=begin    
     all_events.each do |e|
     
         new_event = Event.create!(:name => e.name, :description => e.description, :start_time => e.start_time, :end_time => e.end_time)
         club.events << new_event and club.save!     
     end
=end
  end



  def self.facebookIDFromFacebookPageUrl(url)
    url = "https://graph.facebook.com/?ids=#{url}"
    response_page = HTTParty.get(url)
    return response_page.parsed_response[response_page.keys[0]]['id']
  end

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


