require 'rails_helper'

feature 'User can create measurement' do
  given!(:user) { create(:user) }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:commodity) { create(:commodity, app_id: app.id) }
  given!(:custom_units) { create_list(:custom_unit, 4, app_id: app.id) }

  feature "Visiting #new page" do
    background do
      log_in(user)
      visit new_app_commodity_measurement_path(app, commodity)
    end

    context "When the selected property is from the database" do
      scenario "User should successfully create a measurement", js: true do
        custom_unit = custom_units.sample

        select custom_unit.property, from: "measurement[property]"
        fill_in "measurement[value]", with: "10.56"
        select custom_unit.uom, from: "measurement[uom]"

        click_button "Create Measurement"

        expect(page).to have_text("Measurement successfully created")
        expect(page).to have_text("#{custom_unit.property}: 10.56#{custom_unit.uom}")
      end
    end

    context "When the selected property is from unitwise" do
      scenario "User should successfully create a measurement", js: true do
        property = properties.sample
        unit_of_measure = uom(property).sample

        select property, :from => "measurement[property]"
        fill_in "measurement[value]", with: "5.67"
        select unit_of_measure[0], :from => "measurement[uom]"

        click_button "Create Measurement"

        expect(page).to have_text("Measurement successfully created")
        expect(page).to have_text("#{property}: 5.67#{unit_of_measure[1]}")
      end
    end

    scenario "With incorrect details, a measurement should not be created" do

      fill_in "measurement[value]", with: ""
      click_button "Create Measurement"

      expect(page).to have_content("Value can't be blank")
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