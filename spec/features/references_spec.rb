require 'rails_helper'

feature 'References' do
  background do
    @user = create(:user, email: 'user@example.com', password: 'secretpass')
    @app = create(:app, user_id: @user.id)
    log_in(@user)
  end

  feature "Visiting #index page" do
    scenario "With references present, it should list available references" do
      reference_1 = create(:reference, app: @app)
      reference_2 = create(:reference, app: @app)

      visit app_references_path(@app)

      expect(page).to have_text("References")
      expect(page).to have_content(reference_1.kind)
      expect(page).to have_content(reference_1.source_commodity.short_description)
      expect(page).to have_content(reference_2.kind)
      expect(page).to have_content(reference_2.source_commodity.short_description)
    end

    scenario "With no references present, it should display no references found" do
      visit app_references_path(@app)

      expect(page).to have_text("No references found")
    end
  end

  feature "Visiting #show page" do
    scenario "It should show the reference's details" do
      reference = create(:reference, app_id: @app.id)
      visit app_reference_path(@app, reference)

      expect(page).to have_text(reference.kind)
      expect(page).to have_text(reference.description)
      expect(page).to have_text(reference.source_commodity.short_description)
      expect(page).to have_text(reference.target_commodity.short_description)
    end
  end

  feature "Visiting #new page" do
    background do
      @generic_commodity = create(:generic_commodity, short_description: "Van point easy and efficient cooking")
      @commodity = create(:non_generic_commodity, short_description: "We are in this together")
      visit new_app_reference_path(@app)
    end

    scenario "With correct details, user should successfully create a reference", js: true do

      select "specific_of", :from => "reference_kind"
      select2("#reference_source_commodity_id", "cooking", @generic_commodity.id,@generic_commodity.short_description)
      select2("#reference_target_commodity_id","together", @commodity.id, @commodity.short_description)

      fill_in "Description", with: "description for reference"
      click_button "Create Reference"

      expect(page).to have_text("reference successfully created")
      expect(page).to have_text("description for reference")
      expect(page).to have_text("specific_of")
    end

    scenario "With incorrect details, a reference should not be created" do

      fill_in "Description", with: ""
      select "specific_of", :from => "reference_kind"
      click_button "Create Reference"

      expect(page).to have_content("Description can't be blank")
      expect(page).to have_content("Target commodity must exist")
      expect(page).to have_content("Source commodity must exist")
    end
  end

  feature "Visiting #edit page" do
    background do
      @commodity = create(:non_generic_commodity)
      @reference = create(:reference, app_id: @app.id, target_commodity_id: @commodity.id)
      visit edit_app_reference_path(@app, @reference)
    end

    scenario "It should show the current reference's details" do
      expect(page).to have_text("Edit Reference")
      expect(page).to have_select('reference_kind', selected: @reference.kind)
      # expect(page).to have_select('reference_source_commodity_id', selected: @reference.source_commodity.short_description)
      # expect(page).to have_select('reference_target_commodity_id', selected: @reference.target_commodity.short_description)
      expect(find_field('Description').value).to eq @reference.description
    end

    context "With valid details" do
      scenario "User should successfully update a reference" do
        fill_in "Description", with: "description of reference updated"
        select "alternative_to", :from => "reference_kind"

        click_button "Update Reference"

        expect(page).to have_text("reference successfully updated")
        expect(page).to have_text("description of reference updated")
        expect(page).to have_text("alternative_to")
      end
    end

    context "With invalid details" do
      scenario "Reference should not be updated" do
        fill_in "Description", with: ""
        click_button "Update Reference"

        expect(page).to have_text("Description can't be blank")
      end
    end
  end
end