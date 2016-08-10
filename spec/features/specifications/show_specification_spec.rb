require 'rails_helper'

feature 'User can view a specification' do
  given!(:user) { create(:user) }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:commodity) { create(:commodity, app_id: app.id) }
  given!(:specification) { create(:specification, commodity_id: commodity.id ) }

  background do
    log_in(user)
    visit app_commodity_specification_path(app, commodity, specification)
  end

  feature "Visiting #show page" do
    scenario "It should show the specification's details" do
      expect(page).to have_text("Specification Details")
      expect(page).to have_text("#{specification.property}: #{specification.value}#{specification.uom}")
    end
  end
end

