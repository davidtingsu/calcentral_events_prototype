class Api::ClubsController < ApplicationController
    def show
        render json: Club.find_by_id(params[:id]).to_json
    end
end
