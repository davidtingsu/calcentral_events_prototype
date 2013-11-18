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
    if params[:club]["facebook_url"].start_with?("https://www.facebook.com")
      @club.update_attributes!(params[:club])
      puts "#{params[:club][:facebook_url]}"
      flash[:notice] = "#{@club.name}'s events were successfully added!!!"
      redirect_to club_path(@club)
    else
      flash[:notice] = "#{@club.name}'s events were not added!"
      redirect_to club_path(@club)     
    end 
  end

  def search
    if params[:club].present?
        @club = Club.find_by_name(params[:club])
    end
  end

end