require 'rails_helper'

feature 'Create Commodity' do
  background do
    @user = create(:user, email: 'user@example.com', password: 'secretpass')
    @app = create(:app, user_id: @user.id)
    log_in(@user)
    visit new_app_commodity_path(@app)
  end

  scenario "With correct details", js: true do

    fill_in "commodity[short_description]", with: "a brief short description"
    fill_in "Long description", with: "a very very long description"
    fill_in "Measured in", with: "litres"
    check('Generic')

    click_button "Create Commodity"

    expect(page).to have_text("commodity successfully created")
    expect(page).to have_text("a brief short description")
    expect(page).to have_text("a very very long description")
    expect(page).to have_text("THIS IS A GENERIC COMMODITY")
  end

  scenario "With incorrect details, a commodity should not be created" do

    fill_in "Short description", with: ""
    fill_in "Long description", with: ""
    click_button "Create Commodity"

    expect(page).to have_text("New Commodity")
    expect(page).to have_content("Short description can't be blank")
    expect(page).to have_content("Long description can't be blank")
  end
end
