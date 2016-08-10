require 'rails_helper'

feature 'Creating a Reference' do
  given!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app) { create(:app, user_id: user.id) }
  given!(:generic_commodity) { create(:generic_commodity) }
  given!(:non_generic_commodity) { create(:non_generic_commodity) }
  given!(:reference){ build(:reference) }

  background do
    log_in(user)
    visit new_app_reference_path(app)
  end

  context 'With valid details' do
    scenario 'user should successfully create a reference', js: true do
      generic_search_term = generic_commodity.name.split(" ").sample
      non_generic_search_term = non_generic_commodity.name.split(" ").sample

      select reference.kind, :from => "reference[kind]"
      select2("reference_source_commodity_id", generic_search_term, generic_commodity.id,generic_commodity.name)
      select2("reference_target_commodity_id", non_generic_search_term, non_generic_commodity.id, non_generic_commodity.name)

      fill_in "reference[description]", with: reference.description

      click_button "Create Reference"

      expect(page).to have_text("reference successfully created")
      expect(page).to have_text(reference.description)
      expect(page).to have_text(reference.kind)
    end
  end

  context "With invalid details" do
    scenario 'reference should not be created' do
      fill_in "reference[description]", with: ""
      select reference.kind, :from => "reference[kind]"

      click_button "Create Reference"

      expect(page).to have_content("Description can't be blank")
      expect(page).to have_content("Target commodity can't be blank")
      expect(page).to have_content("Source commodity can't be blank")
    end
  end
end
