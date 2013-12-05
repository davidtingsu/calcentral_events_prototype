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
      #puts "HELLOOOOOOOOO #{ending}"
      ending = ending.to_s


      numbers = start.index(" ")
      start = start[0..numbers-1].gsub("-","")
      numbere = ending.index(" ")
      ending = ending[0..numbere-1].gsub("-","")

      
      
      link = "http://www.google.com/calendar/event?action=TEMPLATE&text="+ name + "&dates="  + start+ "/" + ending
      # puts "HELLOOOOOOOOO #{link}"                                                                                                    
      redirect_to(link)
                 
  end
end
