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
end
