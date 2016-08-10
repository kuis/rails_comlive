require 'rails_helper'

feature 'Adding specification to a commodity' do
  given!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:commodity) { create(:generic_commodity, app_id: app.id) }

  background do
    log_in(user)
    visit app_commodity_path(app, commodity)
  end

  scenario 'User can add a specification to a commodity', js: true do
    click_link "Add Specification"

    within("div#sharedModal") do
      select "length", from: "specification[property]"
      fill_in "specification[value]", with: "40.56"
      select "meter (m)", from: "specification[uom]"

      click_button "Submit"
    end

    expect(page).to have_text("Specification successfully created")
    expect(page).to have_text("length: 40.56m")
  end
end