class EventsController < ApplicationController
 
  around_filter :save_search_values
  def index
    @events = Event.reverse_chronological_order.page(params[:page]).per(10)
    @events.each{
        if params[:access_present].present?
            event.set_friend_list(params[:access_present])
        end
    }

  end

  def search
        fields = ['name']
        page = params[:page].to_i

        if params[:category].present?
            fields << 'categories_name'
        end
        if params[:club].present?
            fields << 'club_name'
        end
        # Event.search( :name_or_club_name_or_categories_name_cont => "").result
        @events = Event.search("#{fields.join("_or_")}_cont".to_sym => params[:q]).result(distinct: true).page(page).per(10)
        @events.each{
            if params[:access_present].present?
                event.set_friend_list(params[:access_present])
            end
        }
        render "index"
  end
  def save_search_values
    session[:q] = params[:q]
    session[:page] = params[:page]
    session[:club] = params[:club]
    session[:category] = params[:category]
    session[:search_type] = params[:search_type]
    yield
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
