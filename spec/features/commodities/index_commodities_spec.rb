require 'rails_helper'

feature 'Listing Commodities' do
  let!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  let!(:app) { create(:app, user_id: user.id) }

  background do
    log_in(user)
  end

  feature "Visiting #index page" do

    context "With commodities present" do
      background do
        create_list(:commodity, 10, app_id: app.id)
      end

      let(:commodities) { app.commodities }

      background do
        visit app_commodities_path(app)
      end

      scenario 'Should show 5 recently added commodities' do
        expect(page).to have_css('.list-group.recently-added .list-group-item', count: 5)
      end

      scenario 'Commodities should be ordered by date created DESC' do
        expect(page).to have_css(".list-group.recently-added a:first-child", text: commodities.recent.first.short_description)
        expect(page).to have_css(".list-group.recently-added a:last-child", text: commodities.recent.limit(5).last.short_description)
      end
    end

    context "With no commodities" do
      scenario "It should display no commodities found" do
        visit app_commodities_path(app)

        expect(page).to have_text("No commodities found")
      end
    end
  end
end