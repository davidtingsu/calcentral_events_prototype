class ApplicationController < ActionController::Base
  before_filter :make_sure_oauth_token_has_not_expired
  around_filter :save_search_values
  protect_from_forgery
  def index
    render template: 'layouts/application'
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def redirect_to_back(default = root_url)
    # http://stackoverflow.com/a/4768755/1123985
    if !request.env["HTTP_REFERER"].blank? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back
    else
      redirect_to default
    end
  end
  helper_method :current_user

  def save_search_values
      session[:q] = params[:q]
      session[:page] = params[:page]
      session[:club] = params[:club]
      session[:category] = params[:category]
      session[:search_type] = params[:search_type]
      yield
    end

  def make_sure_oauth_token_has_not_expired
    if current_user and current_user.oauth_expires_at.past?
        flash[:notice] = "Your session expired. Please sign in again."
        session.clear
        redirect_to_back home_path
    end
  end

end
