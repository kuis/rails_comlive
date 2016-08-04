require 'rails_helper'

feature 'Updating app' do
  given!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app){ create(:app, user_id: user.id) }

  background do
    log_in(user)
    visit edit_app_path(app)
  end

  scenario "With valid details" do

    fill_in "Description", with: "updated app description"
    click_button "Update App"

    expect(page).to have_text("app updated successfully")
    expect(page).to have_text("updated app description")
  end

  scenario "With invalid details" do
    fill_in "Description", with: ""
    click_button "Update App"

    expect(page).to have_text("Description can't be blank")
    expect(page).to have_text("Update App")
  end
end
