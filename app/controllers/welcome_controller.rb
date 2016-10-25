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
    gb = Gibbon::Request.new
    lower_case_md5_hashed_email_address = Digest::MD5.hexdigest(params[:subscribe_email].downcase)
    subscribe = gb.lists('8527b9a2e3').members(lower_case_md5_hashed_email_address).upsert(body: {email_address: params[:subscribe_email], status: "subscribed"})
    redirect_to root_path, notice: t("welcome.subscribe.success_message")
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
