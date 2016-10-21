require 'rails_helper'

feature "Searching for records" do
  given(:user) { create(:user) }
  given!(:brand) { create(:brand, name: "Apple")}
  given!(:standard) { create(:standard, name: "ISO 9000")}
  given!(:commodity) { create(:commodity, name: "Iphone 7")}

  background do
    log_in(user)
    Brand.reindex
    Standard.reindex
    Commodity.reindex
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

  context "If result type of commodity" do
    background do
      within("#navbar-search") do
        fill_in "global-search", with: "iphone"
        click_button "submit-search-btn"
      end
    end

    scenario "It should show an add-to-list button on the result" do
      expect(page).to have_link(commodity.name)
      expect(page).to have_content(commodity.short_description)
      expect(page).to have_button("Add to List")
    end

    scenario "User can add the commodity to his/her list" do
      click_button("Add to List")

      expect(page).to have_text(I18n.t("lists.messages.updated"))
      expect(page).not_to have_button("Add to List")
    end
  end
end
