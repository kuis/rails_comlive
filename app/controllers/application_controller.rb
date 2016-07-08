class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_app

  def current_app
    App.find_by(id: params[:app_id] || params[:id])
  end
end
