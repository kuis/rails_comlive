require 'rails_helper'

feature 'User can edit a measurement' do
  given!(:user) { create(:user) }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:commodity) { create(:commodity, app_id: app.id) }
  given!(:measurement) { create(:measurement, commodity_id: commodity.id ) }

  background do
    log_in(user)
    visit edit_app_commodity_measurement_path(app, commodity, measurement)
  end

  feature "Visiting #edit page" do
    scenario "should show the current measurement's details" do
      uom_value = uom(measurement.property).select{|u| u[1] == measurement.uom }.flatten[0]

      expect(page).to have_text("Edit Measurement")
      expect(page).to have_select('measurement[property]', selected: measurement.property)
      expect(find_field('measurement[value]').value).to eq measurement.value.to_s
      expect(page).to have_select('measurement[uom]', selected: uom_value)
    end

    feature "with valid details" do
      scenario "user should be able to update the measurement", js: true do
        property = properties.sample
        unit_of_measure = uom(property).sample

        select property, from: "measurement[property]"
        fill_in "measurement[value]", with: "30.87"
        select unit_of_measure[0], from: "measurement[uom]"

        click_button "Update Measurement"

        expect(page).to have_text("Measurement updated successfully")
        expect(page).to have_text("#{property}: 30.87#{unit_of_measure[1]}")
      end
    end

    feature "with invalid details" do
      scenario "user should not be able to update the measurement" do
        fill_in "measurement[value]", with: ""
        click_button "Update Measurement"

        expect(page).to have_text("Edit Measurement")
        expect(page).to have_text("Value can't be blank")
      end
    end
  end
end

def properties
  Unitwise::Atom.all.uniq.map {|x| "#{x.property}"}.uniq
end

def uom(property)
  uoms = Unitwise::Atom.all.select{|a|
    a.property == property
  }.map {|i| ["#{i.to_s(:names)} (#{i.to_s(:primary_code)})",i.to_s(:primary_code)] }
  custom_units = CustomUnit.where(property: property)
  uoms += custom_units.map{|u| ["#{u.property} (#{u.uom})", u.uom] } if custom_units.any?
  return uoms
end