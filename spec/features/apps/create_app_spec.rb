require 'rails_helper'

feature 'App Creation' do
  background do
    @user = create(:user, email: 'user@example.com', password: 'secretpass')
    log_in(@user)
  end

  scenario "With valid details" do
    visit new_app_path

    app = build(:app)

    fill_in "Description", with: app.description
    click_button "Create App"

    expect(page).to have_text("app created successfully")
    expect(page).to have_text(app.description)
  end

  scenario "With invalid details" do
    visit new_app_path

    fill_in "Description", with: ""
    click_button "Create App"

    expect(page).to have_text("Create App")
    expect(page).to have_text("Description can't be blank")
  end
end