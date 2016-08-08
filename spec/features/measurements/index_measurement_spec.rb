require 'rails_helper'

feature 'List measurements' do
  given!(:user) { create(:user) }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:commodity) { create(:commodity, app_id: app.id) }

  background do
    log_in(user)
  end

  feature "Visiting #index page" do
    scenario "With measurements present, it should list available measurements" do
      measurement_1 = create(:measurement, commodity_id: commodity.id)
      measurement_2 = create(:measurement, commodity_id: commodity.id)

      visit app_commodity_measurements_path(app, commodity)

      expect(page).to have_text("#{measurement_1.property}: #{measurement_1.value}#{measurement_1.uom}")
      expect(page).to have_text("#{measurement_2.property}: #{measurement_2.value}#{measurement_2.uom}")
    end

    scenario "With no measurements present, it should display no measurements found" do
      visit app_commodity_measurements_path(app, commodity)
      expect(page).to have_text("No measurements found")
    end
  end
end
