require 'rails_helper'

feature 'User signs in' do
  given!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }

  scenario 'with valid email and password' do
    sign_in_with(user.email, user.password)

    expect(page).to have_content('Signed in successfully')
    expect(page).to have_link("Logout", href: destroy_user_session_path)
  end

  scenario "with invalid email" do
    sign_in_with('invalid.com', 'secretpass')

    expect(page).to have_content("Invalid Email or password.")
  end

  scenario "with invalid password" do
    sign_in_with(user.email, 'invalidpass')

    expect(page).to have_content("Invalid Email or password.")
  end

  scenario "redirects to last visited app if user visited app" do
    log_in(user)
    4.times { create(:app, user: user) }
    app = user.apps.sample
    visit app_path(app)
    click_link "Logout"

    log_in(user)
    expect(page.current_path).to eq app_path(app)
  end

  scenario "redirects to root path if no last visited app" do
    log_in(user)
    click_link "Logout"
    log_in(user)
    expect(page.current_path).to eq root_path
  end
end