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
      flash[:success] = "#{@club.name} successfully updated!"
      redirect_to_back search_clubs_path
    else
      flash[:notice] = "#{@club.name} not updated!"
      redirect_to_back search_clubs_path
    end 
  end

  def search
    fields = ['name']
    page = params[:page].to_i

    if params[:category].present?
        fields << 'categories_name'
    end
    @clubs = Club.search("#{fields.join("_or_")}_cont".to_sym => params[:q]).result(distinct: true).page(page).per(10)
    render "index"
  end

end
