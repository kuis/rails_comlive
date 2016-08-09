require 'rails_helper'

feature "Visiting reference#show page" do

  given!(:user){ create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:reference) { create(:reference, app: app) }

  background do
    log_in(user)
    visit app_reference_path(app, reference)
  end

  scenario "Should show the reference's details" do

    expect(page).to have_text(reference.kind)
    expect(page).to have_text(reference.description)
    expect(page).to have_text(reference.source_commodity.short_description)
    expect(page).to have_text(reference.target_commodity.short_description)
  end
end