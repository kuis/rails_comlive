require 'rails_helper'

RSpec.describe SearchesController, :type => :controller do
  describe "GET #index" do
    it "returns 200 http status code" do
      get :index
      expect(response.status).to eq 200
    end

    context "With search params" do
      it "returns results matching the search query" do
        brand = create(:brand, name: "Apple")
        Brand.reindex
        get :index, params: { query: "appl", format: "json" }

        expect(json_response).to be_an Array
        expect(json_response[0]["id"]).to eq brand.id
        expect(json_response[0]["name"]).to match(/Apple/)
      end
    end
  end

end
