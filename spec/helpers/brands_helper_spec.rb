require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the BrandsHelper. For example:
#
# describe BrandsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe BrandsHelper, :type => :helper do
  describe ".options_for_brands" do
    it "returns official brands related to the current user's apps" do
      user = FactoryGirl.create(:user)
      2.times { FactoryGirl.create(:app, user: user) }
      first_app  = user.apps.first
      second_app = user.apps.last
      official_brand   = FactoryGirl.create(:official_brand, app: first_app)
      FactoryGirl.create(:brand, app: second_app)
      options = helper.options_for_brands(user)

      expect(options).to match_array([[official_brand.name, "Brand-#{official_brand.id}"]])
    end
  end
end
