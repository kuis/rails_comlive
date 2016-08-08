require 'rails_helper'

feature 'Adding packaging to a commodity' do
  given!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:commodity) { create(:generic_commodity, app_id: app.id) }
  given(:packaging) { build(:packaging) }

  background do
    log_in(user)
    visit app_commodity_path(app, commodity)
  end

  scenario 'User can add packaging to a commodity', js: true do
    click_link "Add Packaging"

    within("div#sharedModal") do
      fill_in 'packaging[name]', with: packaging.name
      fill_in 'packaging[description]',with: packaging.description
      fill_in 'packaging[quantity]', with: packaging.quantity
      fill_in 'packaging[uom]', with: packaging.uom

      click_button 'Submit'
    end

    expect(page).to have_content(packaging.name)
    expect(page).to have_content(packaging.description)
    expect(page).to have_content(packaging.quantity)
    expect(page).to have_content(packaging.uom)
    expect(page).to have_content("Packaging successfully saved")
  end

end