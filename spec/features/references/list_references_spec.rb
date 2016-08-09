require 'rails_helper'

feature "Visiting references#index page" do
  given!(:user){ create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:reference_x) { create(:reference, app: app) }
  given!(:reference_y) { create(:reference, app: app) }

  background do
    log_in(user)
    visit app_references_path(app)
  end

  context "With references present" do
    scenario "it should list available references" do
      expect(page).to have_text("References")
      expect(page).to have_content(reference_x.kind)
      expect(page).to have_content(reference_x.source_commodity.short_description)
      expect(page).to have_content(reference_y.kind)
      expect(page).to have_content(reference_y.source_commodity.short_description)
    end
  end
end

