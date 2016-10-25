require 'rails_helper'

feature 'Welcome#subscribe' do
  let(:message) { OpenStruct.new(email: "johndoe@email.com")}

  background do
    visit root_path
  end

  scenario "User can subscribe to newsletter" do
    fill_in "email", with: message.email

    click_button "Submit"

    expect(page).to have_content(I18n.t("welcome.subscribe.success_message"))
  end
end