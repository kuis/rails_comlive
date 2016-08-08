require 'rails_helper'

feature 'Adding link to a commodity' do
  given!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:commodity) { create(:generic_commodity, app_id: app.id) }
  given(:link) { build(:link) }

  background do
    log_in(user)
    visit app_commodity_path(app, commodity)
  end

  scenario 'User can add a link to a commodity', js: true do
    click_link "Add Link"

    within("div#sharedModal") do
      fill_in 'link[url]', with: link.url
      fill_in 'link[description]',with: link.description
      select commodity.short_description, from: 'link[commodity_id]'

      click_button 'Submit'
    end

    expect(page).to have_link('Open Link', href: link.url)
    expect(page).to have_content(link.description)
    expect(page).to have_content("link successfully created")
  end

end