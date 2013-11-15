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
  end
end
