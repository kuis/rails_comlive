require 'rails_helper'

feature 'Listing Commodities' do
  background do
    @user = create(:user, email: 'user@example.com', password: 'secretpass')
    @app = create(:app, user_id: @user.id)
    log_in(@user)
  end

  feature "Visiting #index page" do
    scenario "With commodities present, it should list available commodities" do
      commodity_1 = create(:commodity, app_id: @app.id)
      commodity_2 = create(:commodity, app_id: @app.id)

      visit app_commodities_path(@app)

      expect(page).to have_text(commodity_1.short_description)
      expect(page).to have_text(commodity_2.short_description)
    end

    scenario "With no commodities present, it should display no commodities found" do
      visit app_commodities_path(@app)

      expect(page).to have_text("No commodities found")
    end
  end
end