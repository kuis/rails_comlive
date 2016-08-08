require 'rails_helper'

feature 'Adding measurement to a commodity' do
  given!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:commodity) { create(:generic_commodity, app_id: app.id) }

  background do
    log_in(user)
    visit app_commodity_path(app, commodity)
  end

  scenario 'User can add a measurement to a commodity', js: true do
    click_link "Add Measurement"

    within("div#sharedModal") do
      select "length", from: "measurement[property]"
      fill_in "measurement[value]", with: "40.56"
      select "meter (m)", from: "measurement[uom]"

      click_button "Submit"
    end

    expect(page).to have_text("Measurement successfully created")
    expect(page).to have_text("length: 40.56m")
  end
end