require 'rails_helper'

feature 'Recently Visited Commodities' do
  let!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  let!(:app) { create(:app, user_id: user.id) }

  background do
    log_in(user)
    create_list(:commodity, 10, app_id: app.id)
    app.commodities.each {|c| visit app_commodity_path(app,c) }
    visit app_commodities_path(app)
  end

  scenario "should show a maximum of 5 commodities" do
    expect(page).to have_css('.list-group.recently-visited .list-group-item', count: 5)
  end

  scenario "should show a list commodities ordered last first" do
    commodities = app.commodities

    expect(page).to have_css(".list-group.recently-visited a:first-child", text: commodities.last(5).last.short_description)
    expect(page).to have_css(".list-group.recently-visited a:last-child", text: commodities.last(5).first.short_description)

  end
end
