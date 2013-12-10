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
        fields = ['name']

        if params[:category].present?
            fields << 'categories_name'
        end
        if params[:club].present?
            fields << 'club_name'
        end
        # Event.search( :name_or_club_name_or_categories_name_cont => "").result
        @events = model_search(Event, fields)
        @events.each{ |event|
            if event.is_facebook? and current_user.present?
              #TODO get current_user access token
              event.set_friend_list current_user.oauth_token
            end
        }
        render "index"
  end


  def publishtogoogle
      event = Event.find_by_id(params[:id])
      if event.nil?
         flash[:warning] = "No such event"
         redirect_to home_path
      else
      redirect_to(event.to_google_calendar_url)
    end
  end
end
