class ClubsController < ApplicationController
  around_filter :save_search_values

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
    fields = ['name']
    page = params[:page].to_i

    if params[:category].present?
        fields << 'categories_name'
    end
    @clubs = Club.search("#{fields.join("_or_")}_cont".to_sym => params[:q]).result(distinct: true).page(page).per(10)
    render "index"
  end

  private

  def save_search_values
    session[:q] = params[:q]
    session[:page] = params[:page]
    session[:club] = params[:club]
    session[:category] = params[:category]
    session[:search_type] = params[:search_type]
    yield
  end

end
