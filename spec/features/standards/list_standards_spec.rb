require 'rails_helper'

feature 'Listing Standards' do
  given!(:user) { create(:user) }

  background do
    log_in(user)
  end

  feature "Visiting #index page" do
    scenario "With standards present, it should list available standards" do
      create_list(:standard, 2)

      visit standards_path

      Standard.all.each do |standard|
        expect(page).to have_text(standard.name)
      end
    end

    scenario "With no standards present, it should display no standards found" do
      visit standards_path

      expect(page).to have_text("No standards found")
    end
  end
end
