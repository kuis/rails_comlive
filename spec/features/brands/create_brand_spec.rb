require 'rails_helper'

feature 'Creating a Brand' do
  given!(:user) { create(:user, email: 'user@example.com', password: 'secretpass') }
  given!(:app) { create(:app, user_id: user.id) }
  given(:brand) { build(:brand) }

  background do
    log_in(user)
    visit new_app_brand_path(app)
  end

  context "With valid details" do
    scenario "should successfully create the brand" do
      fill_in 'brand[name]', with: brand.name
      fill_in 'brand[description]', with: brand.description

      click_button 'Create Brand'

      expect(page).to have_content("Brand Successfully created")
      expect(page).to have_content(brand.name)
      expect(page).to have_content(brand.description)
    end
  end

  context "With invalid details" do
    scenario 'should not create the brand' do
      fill_in 'brand[name]', with: ''
      fill_in 'brand[description]', with: ''

      click_button 'Create Brand'

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Description can't be blank")
    end
  end
end
