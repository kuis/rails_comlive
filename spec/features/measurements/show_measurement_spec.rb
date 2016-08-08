require 'rails_helper'

feature 'User can view a measurement' do
  given!(:user) { create(:user) }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:commodity) { create(:commodity, app_id: app.id) }
  given!(:measurement) { create(:measurement, commodity_id: commodity.id ) }

  background do
    log_in(user)
    visit app_commodity_measurement_path(app, commodity, measurement)
  end

  feature "Visiting #show page" do
    scenario "It should show the measurement's details" do
      expect(page).to have_text("Measurement Details")
      expect(page).to have_text("#{measurement.property}: #{measurement.value}#{measurement.uom}")
    end
  end

end

