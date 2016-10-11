require 'rails_helper'

RSpec.describe WelcomeController, :type => :controller do
  describe "GET #landing" do
    it "returns 200 http code status" do
      get :landing
      expect(response.status).to eq 200
    end
  end

  describe "GET #add_items" do
    it "returns 200 http status code" do
      get :add_items
      expect(response.status).to eq 200
    end
  end
end
