require 'rails_helper'

feature 'Show App' do
  given!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app) { create(:app, user_id: user.id) }

  background do
    log_in(user)
    visit app_path(app)
  end

  scenario "user can view app" do
    expect(page).to have_text(app.description)
  end
end
