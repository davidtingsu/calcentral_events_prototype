class EventsController < ApplicationController
 
  def index
    @events = Event.reverse_chronological_order.page(params[:page]).per(10)
    @events.each{|event|
        if event.is_facebook? and current_user.present?
          #TODO get current_user access token
          event.set_friend_list current_user.oauth_token
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
            if event.is_facebook? and current_user.present?
              #TODO get current_user access token
              event.set_friend_list current_user.oauth_token
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
