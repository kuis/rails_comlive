require 'rails_helper'

feature 'User logout' do
  background do
    @user = create(:user, email: 'user@example.com', password: 'secretpass')
    log_in(@user)
  end

  scenario 'Logout from system' do
    click_link "Logout"
    expect(page).to have_content("Signed out successfully.")
  end
end