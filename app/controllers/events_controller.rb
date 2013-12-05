class EventsController < ApplicationController
 
  def index
    
    
  end

  def search
        @events = Event.reverse_chronological_order.all
        if params[:category].present?
            @events = Event.find_by_category(*params[:category].split(','))
        end
        if params[:club].present?
            @events = Event.find_by_club(*params[:club].split(','))
        end
        @tem = true
  end

  def googlecal
      name = params[:name]
      name = name.to_s
      start = params[:start]
      start = start.to_s
      ending = params[:ends]
      ending = ending.to_s
      des = params[:description]
      des = des.to_s
      if !des.nil? && !des.empty?
         if des.include?(" ")
            des = des.gsub(" ", "%20")
          end
      end
      if des.nil? || des.empty?
        des = "No%20Description"
      end
      
      numbers = start.index(" ")
      start = start[0..numbers-1].gsub("-","")
      numbere = ending.index(" ")
      ending = ending[0..numbere-1].gsub("-","")

      
      
      link = "http://www.google.com/calendar/event?action=TEMPLATE&text="+ name + "&dates="  + start+ "/" + ending + "&details=" +des

     
                                                                                                          
      redirect_to(link)
                 
  end
end
