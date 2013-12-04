class Api::EventsController < ApplicationController
    def index
        limit = params[:limit]
        if limit.present?
            render json: Event.limit(limit.to_i).to_json
        else
            render json: Event.all.to_json
        end
    end

    def show
        render json: Event.find_by_id(params[:id]).to_json
    end
end
