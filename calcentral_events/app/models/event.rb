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
     events = MiniFB.fql(@@access_token,"SELECT eid, name, location, description, start_time, end_time, timezone FROM event where creator = #{CGI.escape(facebook_page_id)}") if facebook_page_id.present?
     events.each do |e|
        
         Event.create!(:name => e['name'], :description => e['description'], :facebook_id => e['eid'], :start_time => e['start_time'], :end_time => e['end_time'])
     end
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
    xml = URI.parse(uri).read
    doc = Nokogiri::XML(xml)
       
    doc.xpath('//item').each do |e|
      
      title_date = (e/'./title').text.to_s

      title_date_array = title_date.split(",")
      title, date = title_date_array[0], title_date_array[1]
      description = ActionView::Base.full_sanitizer.sanitize((e/'./description').text)
      event_id = (e/'./link').text.split("?")[1].split("&")[0].split("=")[1]
      
      start_end_time = self.parsingHtmlAndReturnTimes(event_id)
      
      start_time = start_end_time[0]
      end_time = start_end_time[1]   
      
      Event.create!(:name => title, :description => description, :facebook_id => event_id, :start_time => start_time, :end_time => end_time)
    
    end
  end

  def self.parsingHtmlAndReturnTimes(event_id)
    htmlUri =  "http://events.berkeley.edu/index.php/html/sn/pubaff/type/day/tab/all_events.html"
    doc = Nokogiri::HTML(open(htmlUri))
    puts event_id
  
    counter = 0    
    doc.css('div.event a').each do |link|

      if (link['href'][0] == "?")    

          if (link['href'].split("&")[0].split("=")[1] == event_id && link['href'].split("#")[1] != "exceptiondates")  
             
              firstComma = doc.css('div.event p')[counter].text.split("|")[1].gsub(/\s/, '').index(",")
              
              secondComma = doc.css('div.event p')[counter].text.split("|")[1].gsub(/\s/, '').sub(",", " ").index(",")
              puts secondComma
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
              return start_time, end_time

          elsif (link['href'].split("&")[0].split("=")[1] != event_id && link['href'].split("#")[1] == "exceptiondates")
              next
      
          else
              counter = counter + 1
          end
      end

    end

    return start_time, end_time 
  end

end 


