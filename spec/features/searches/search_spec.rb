require 'rails_helper'

feature "Searching for records" do
  given(:user) { create(:user) }
  given!(:brand) { create(:brand, name: "Apple")}
  given!(:standard) { create(:standard, name: "ISO 9000")}

  background do
    log_in(user)
    Brand.reindex
    Standard.reindex
  end

  scenario "It should return results matching the search query" do
    within("#navbar-search") do
      fill_in "global-search", with: "appl"
      click_button "submit-search-btn"
    end
    expect(page).to have_link(brand.name)
    expect(page).to have_content(brand.description)

    expect(page).not_to have_link(standard.name)
    expect(page).not_to have_content(standard.description)
  end
end
