class WelcomeController < ApplicationController
  layout 'landing', except: [:dashboard,:add_items]

  def landing
  end

  def pricing
  end

  def team
  end

  def contact
  end

  def dashboard
    @recent_commodities = Commodity.recent.limit(5)
  end

  def add_items
  end

  def send_message
    NotificationMailer.contact_message(params[:name], params[:email], params[:message]).deliver!
    redirect_to contact_path, notice: t("welcome.contact.success_message")
  end
end
