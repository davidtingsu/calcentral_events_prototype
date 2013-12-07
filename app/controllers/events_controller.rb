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

  def publishtogoogle
      event = Event.find_by_id(params[:id])
      if event.nil?
         flash["No such event"]
         redirect_to("/")
      else
      redirect_to(event.to_google_calendar_url)
    end
                 
  end
end
