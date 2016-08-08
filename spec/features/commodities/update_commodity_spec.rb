require 'rails_helper'

feature 'Updating commodities' do
  background do
    @user = create(:user, email: 'user@example.com', password: 'secretpass')
    @app = create(:app, user_id: @user.id)
    log_in(@user)
    @commodity = create(:commodity, app_id: @app.id)
    visit edit_app_commodity_path(@app, @commodity)
  end

  scenario "It should show the current commodity's details" do
    expect(page).to have_text("Edit Commodity")
    expect(find_field('Short description').value).to eq @commodity.short_description
    expect(find_field('Long description').value).to eq @commodity.long_description
  end

  scenario "With valid details" do
    fill_in "Short description", with: "short description updated"
    fill_in "Long description", with: "very long description updated"
    click_button "Update Commodity"

    expect(page).to have_text("commodity successfully updated")
    expect(page).to have_text("short description updated")
    expect(page).to have_text("very long description updated")
  end

  scenario "With invalid details" do
    fill_in "Short description", with: ""
    click_button "Update Commodity"

    expect(page).to have_text("Edit Commodity")
    expect(page).to have_text("Short description can't be blank")
  end
end

