require 'rails_helper'

feature 'Listing Specification' do
  given!(:user) { create(:user) }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:commodity) { create(:commodity, app_id: app.id) }

  background do
    log_in(user)
  end

  feature "Visiting #index page" do
    scenario "With specifications present, it should list available specifications" do
      specification_1 = create(:specification, commodity_id: commodity.id)
      specification_2 = create(:specification, commodity_id: commodity.id)

      visit app_commodity_specifications_path(app, commodity)

      expect(page).to have_text("#{specification_1.property}: #{specification_1.value}#{specification_1.uom}")
      expect(page).to have_text("#{specification_2.property}: #{specification_2.value}#{specification_2.uom}")
    end

    scenario "With no specifications present, it should display no specifications found" do
      visit app_commodity_specifications_path(app, commodity)
      expect(page).to have_text("No specifications found")
    end
  end
end
