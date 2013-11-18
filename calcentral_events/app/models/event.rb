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


  def self.getFacebookEvents(facebook_page_id)
     #eventsArray = []
      MiniFB.fql(@@access_token,"SELECT eid, name, location, description, start_time, end_time, timezone FROM event where creator = #{CGI.escape(facebook_page_id)}") if facebook_page_id.present?
  
     #events.each do |e|
        
      #   newEvent = Event.create!(:name => e['name'], :description => e['description'], :start_time => e['start_time'], :end_time => e['end_time'])
#	 eventsArray.push(newEvent)
 #    end

  #   return eventsArray
  end



  def self.facebookIDFromFacebookPageUrl(url)
    url = "https://graph.facebook.com/?ids=#{url}"
    response_page = HTTParty.get(url)
    return response_page.parsed_response[response_page.keys[0]]['id']
  end

  def self.makeUriForXml    
    return "http://events.berkeley.edu/index.php/rss/sn/pubaff/type/day/tab/all_events.html"
  end

  def self.responseEventObject(uri)
    if uri == ""
        return ""
    end
    
    xml = URI.parse(uri).read
    doc = Nokogiri::XML(xml)
    hashTable = parsingHtmlAndReturnTimes
    eventsArray = []
    
       
    doc.xpath('//item').each do |e|
      
      title_date = (e/'./title').text.to_s

      title_date_array = title_date.split(",")
      title, date = title_date_array[0], title_date_array[1]
      description = ActionView::Base.full_sanitizer.sanitize((e/'./description').text)
      event_id = (e/'./link').text.split("?")[1].split("&")[0].split("=")[1]
      start_end_time = hashTable[event_id]
     
      
      start_time = start_end_time[0]
      end_time = start_end_time[1]   
      
      
      new_event = Event.create!(:name => title, :description => description, :facebook_id => event_id, :start_time => start_time, :end_time => end_time)
      eventsArray.push(new_event)
      
    
    end
    #debugger
    return eventsArray
  end


  def self.parsingHtmlAndReturnTimes
    htmlUri =  "http://events.berkeley.edu/index.php/html/sn/pubaff/type/day/tab/all_events.html"
    doc = Nokogiri::HTML(open(htmlUri))
  
    counter = 0
    hashTable = {}
  
    doc.css('div.event a').each do |link|
      arr = []

      if (link['href'][0] == "?")    

          if (link['href'].split("#")[1] != "exceptiondates")  
             
              firstComma = doc.css('div.event p')[counter].text.split("|")[1].gsub(/\s/, '').index(",")
              
              secondComma = doc.css('div.event p')[counter].text.split("|")[1].gsub(/\s/, '').sub(",", " ").index(",")
      
              if (secondComma != nil && firstComma != nil)
             
                  commaDivided = doc.css('div.event p')[counter].text.split("|")[1].gsub(/\s/, '').gsub(/\W/, " ").insert(firstComma + 5, ",").insert(secondComma + 6, ",")
              elsif (secondComma == nil && firstComma != nil)
                
                  commaDivided = doc.css('div.event p')[counter].text.split("|")[1].gsub(/\s/, '').gsub(/\W/, " ").insert(firstComma + 5, ",")
                
              elsif (secondComma == nil && firstComma == nil)
                      commaDivided = doc.css('div.event p')[counter].text.split("|")[1].gsub(/\s/, '').gsub(/\W/, " ")
             
              end

              s_time = commaDivided.split(",")[0]
              e_time = commaDivided.split(",")[1]
            
              if ((doc.css('div.event p')[counter].text.split("|")[2].delete "\t" "\n").split("-").size == 2)
                  start_time = s_time + " " + (doc.css('div.event p')[counter].text.split("|")[2].delete "\t" "\n").split("-")[0]
                  if (e_time != nil)
                    end_time = e_time + " " + (doc.css('div.event p')[counter].text.split("|")[2].delete "\t" "\n").split("-")[1]
                  else
                    end_time = (doc.css('div.event p')[counter].text.split("|")[2].delete "\t" "\n").split("-")[1]
                  end
       
              elsif ((doc.css('div.event p')[counter].text.split("|")[2].delete "\t" "\n").split("-").size == 1)
                  start_time = s_time + " " + (doc.css('div.event p')[counter].text.split("|")[2].delete "\t" "\n").split("-")[0]
                  end_time = e_time
               
              end
              #debugger
              hashTable[link['href'].split("&")[0].split("=")[1]] = arr.push(start_time, end_time)
              counter = counter + 1
              
             

          elsif (link['href'].split("#")[1] == "exceptiondates")
              next
 
          end
      end

    end
    #debugger
    return hashTable 
  end

end 


