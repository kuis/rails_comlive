class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :last_accessed_app
  before_action :set_locale

  helper_method :current_user, :current_app, :user_signed_in?, :commodity_url

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if user_signed_in?
  end

  def user_signed_in?
    session[:user_id].present?
  end

  def current_app
    return nil unless current_user
    return current_user.default_app unless cookies[:last_app_id]
    App.find(cookies[:last_app_id])
    # return @current_app if defined?(@current_app)
    # @current_app ||= begin
    #   app = App.find(cookies[:last_app_id]) if cookies[:last_app_id]
    #   app = current_user.default_app if current_user
    # end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def last_accessed_app
    return unless request.get?
    return unless request.path.match(/\/apps\/(\d+)/)
    cookies.permanent[:last_app_id] = request.path.match(/\/apps\/(\d+)/)[1]
  end

  def commodity_url(commodity)
    return commodity_path(commodity) if user_signed_in?
    slugged_commodity_path(commodity.uuid, commodity.name.parameterize)
  end

  def set_locale
    if params[:locale]
      return I18n.default_locale unless I18n.available_locales.include?(params[:locale].to_sym)
      I18n.locale = params[:locale].to_sym
    else
      I18n.default_locale
    end
  end

  def default_url_options(options = {})
    { locale: I18n.locale }
  end

  def authenticate_user!
    redirect_to login_path, alert: "You need to sign in or sign up before continuing." unless current_user.present?
  end
end
