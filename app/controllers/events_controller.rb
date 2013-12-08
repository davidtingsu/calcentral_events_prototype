class EventsController < ApplicationController
 
  def index
    @events = Event.reverse_chronological_order.page(params[:page]).per(10)
    @events.each{
        if params[:access_present].present?
            event.set_friend_list(params[:access_present])
        end
    }

  end

  def search
        @events = Event.reverse_chronological_order.page(params[:page]).per(10)
        if params[:category].present?
            @events = Event.find_by_category(*params[:category].split(',')).page(params[:page]).per(10)
        end
        if params[:club].present?
            @events = Event.find_by_club(*params[:club].split(',')).page(params[:page]).per(10)
        end
        @events.each{
            if params[:access_present].present?
                event.set_friend_list(params[:access_present])
            end
        }
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
