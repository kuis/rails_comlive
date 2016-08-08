require 'rails_helper'

feature 'Create Link' do
  given!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:commodity) { create(:commodity, app_id: app.id) }
  given(:link) { build(:link) }

  background do
    log_in(user)
    visit new_app_link_path(app)
  end

  feature "Visiting #new page" do
    scenario "With correct details, user should successfully create a link" do

      fill_in "link[url]", with: link.url
      fill_in "link[description]", with: link.description
      select commodity.short_description, from: "link[commodity_id]"

      click_button "Create Link"

      expect(page).to have_text("link successfully created")
      expect(page).to have_link("Open Link", href: link.url)
      expect(page).to have_text(link.description)
    end

    scenario "With incorrect details, a link should not be created" do

      fill_in "Url", with: ""
      fill_in "Description", with: ""
      select commodity.short_description, :from => "link_commodity_id"
      click_button "Create Link"

      expect(page).to have_button("Create Link")
      expect(page).to have_content("Url can't be blank")
      expect(page).to have_content("Description can't be blank")
    end
  end
end
