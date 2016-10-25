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

  describe "GET #dashboard" do
    it "returns 200 http status code" do
      get :dashboard
      expect(response.status).to eq 200
    end
  end

  describe "POST #subscribe" do
    it "subscribes the user" do
      post :subscribe, params:  { email: "johndoe@email.com"  }
      expect(response.status).to eq 302
    end
  end
end
