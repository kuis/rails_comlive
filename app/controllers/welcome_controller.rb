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

  def subscribe
    begin
      gb = Gibbon::Request.new
      hashed_email = Digest::MD5.hexdigest(params[:subscribe_email].downcase)
      gb.lists('8527b9a2e3').members(hashed_email).upsert(body: {email_address: params[:subscribe_email], status: "subscribed"})
      flash[:notice] = t("welcome.subscribe.success_message")
    rescue Gibbon::MailChimpError => e
      response = JSON.parse(e.raw_body)
      message = response["detail"]
      flash[:alert] = message
    end
    redirect_to root_path
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
