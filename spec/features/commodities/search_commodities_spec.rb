require 'rails_helper'

feature 'Searching commodities' do
  let!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  let!(:app) { create(:app, user_id: user.id) }

  background do
    log_in(user)
    visit app_commodities_path(app)
  end

  scenario "returns a list of matching commodities" do
    samsung  = create(:commodity, short_description: "Samsung Tvs")
    sony     = create(:commodity, short_description: "Sony home theatre")
    hotpoint = create(:commodity, short_description: "Hotpoint electronics")

    fill_in 'commodity-search', with: 'samsung'
    click_button "search-btn"

    expect(page).to have_content(samsung.short_description)
  end
end

