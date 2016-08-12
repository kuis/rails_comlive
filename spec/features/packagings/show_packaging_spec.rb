require 'rails_helper'

feature 'Packaging#show' do
  given!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:commodity) { create(:generic_commodity, app_id: app.id) }
  given!(:packaging) { create(:packaging, commodity_id: commodity.id) }

  background do
    log_in(user)
    visit app_commodity_packaging_path(app, commodity, packaging)
  end


  scenario "User should see packaging details" do
    expect(page).to have_content(packaging.name)
    expect(page).to have_content(packaging.quantity)
    expect(page).to have_content(packaging.description)
    expect(page).to have_content(packaging.uom)
  end
end
