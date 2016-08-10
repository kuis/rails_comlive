require 'rails_helper'

feature 'Update Link' do
  given!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:commodity) { create(:commodity, app_id: app.id) }
  given!(:link) { create(:link, app_id: app.id) }

  background do
    log_in(user)
    visit edit_app_link_path(app, link)
  end

  feature "Visiting #edit page" do
    scenario "It should show the current link's details" do
      expect(page).to have_text("Edit Link")
      expect(find_field('link[url]').value).to eq link.url
      expect(page).to have_select('link[commodity_id]', selected: link.commodity.name)
      expect(find_field('link[description]').value).to eq link.description
    end

    scenario "With correct details, user should successfully update a link" do
      fill_in "link[description]", with: "description updated"
      fill_in "link[url]", with: "https://www.google.com/search?q=strengtheningthenumbers"
      select commodity.name, :from => "link[commodity_id]"

      click_button "Update Link"

      expect(page).to have_text("link successfully updated")
      expect(page).to have_text("description updated")
      expect(page).to have_link("Open Link", href: "https://www.google.com/search?q=strengtheningthenumbers")
    end

    scenario "With incorrect details, link should not be updated" do
      fill_in "link[description]", with: ""
      click_button "Update Link"

      expect(page).to have_text("Edit Link")
      expect(page).to have_text("Description can't be blank")
    end
  end
end