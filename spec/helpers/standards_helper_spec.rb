require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the StandardsHelper. For example:
#
# describe StandardsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe StandardsHelper, :type => :helper do
  describe ".options_for_standards" do
    it "returns official standards related to the current user's apps" do
      user = FactoryGirl.create(:user)
      2.times { FactoryGirl.create(:app, user: user) }
      first_app  = user.apps.first
      second_app = user.apps.last
      official_standard   = FactoryGirl.create(:official_standard, app: first_app)
      FactoryGirl.create(:standard, app: second_app)
      options = helper.options_for_standards(user)

      expect(options).to match_array([[official_standard.name, "Standard-#{official_standard.id}"]])
    end
  end
end
