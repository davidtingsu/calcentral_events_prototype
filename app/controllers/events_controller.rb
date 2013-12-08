class EventsController < ApplicationController
  def index
    @events = Event.reverse_chronological_order.page(params[:page]).per(10)
    @events.each{
        if params[:access_token].token?
            event.set_friend_list(params[:access_token])
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
            if params[:access_token].token?
                event.set_friend_list(params[:access_token])
            end
        }
  end
end
