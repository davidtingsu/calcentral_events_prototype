class ClubsController < ApplicationController
  def index
  end

  def show
    id = params[:id]
    @club = Club.find(id)    
  end

  def edit
    @club = Club.find(params[:id])
  end

  def update
    @club = Club.find(params[:id])
    @club.update_attributes!(params[:club])
    flash[:notice] = "#{@club.name}'s events were successfully added!!!"
    redirect_to club_path(@club)
  end

  def search
    if params[:club].present?
        @club = Club.find_by_name(params[:club])
    end
  end

end