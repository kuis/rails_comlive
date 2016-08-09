require 'rails_helper'

feature 'Searching commodities' do
  given!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:samsung){ create(:commodity, app_id: app.id, short_description: "Samsung Tvs") }
  given!(:sony){ create(:commodity,  app_id: app.id, short_description: "Sony home theatre") }
  given!(:hotpoint){ create(:commodity,  app_id: app.id, short_description: "Hotpoint electronics") }

  background do
    log_in(user)
    Commodity.reindex
    visit app_commodities_path(app)
  end

  scenario "returns a list of matching commodities" do
    fill_in 'commodity-search', with: 'samsung'
    click_button "search-btn"

    expect(page).to have_content(samsung.short_description)
    expect(page).to have_content(samsung.long_description)
    expect(page).not_to have_content(sony.short_description)
    expect(page).not_to have_content(hotpoint.short_description)
  end

  scenario "renders a type ahead suggestion", js: true do
    type_ahead("commodity-search", { with: "sony"} )

    expect(page).to have_link(sony.short_description, href: app_commodity_path(app, sony) )
  end

  scenario "clicking suggestion redirects to commodity", js: true do
    type_ahead("commodity-search", { with: "hotpoint"} )

    within("div.tt-dataset") do
      click_link hotpoint.short_description
    end

    expect(page.current_path).to eq app_commodity_path(app, hotpoint)
  end
end

