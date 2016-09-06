require 'rails_helper'

RSpec.describe LinksController, :type => :controller do
  let!(:user) { create(:user) }
  let!(:app) { create(:app) }
  let!(:commodity_reference) { create(:commodity_reference, app: app) }
  let!(:link){  create(:link, app_id: app.id) }

  before(:each) do
    sign_in user
  end

  describe "GET #new" do
    it "returns 200 http status code" do
      get :new, params: { app_id: app.id }
      expect(response.status).to eq 200
    end
  end

  describe "POST #create" do

    context "with valid attributes" do
      it "saves the new link in the database" do
        expect{
          post :create, params: { app_id: app.id, link: attributes_for(:link, commodity_reference_id: commodity_reference.id) }
        }.to change(Link, :count).by(1)
      end
      it "redirects to link's commodity#show path" do
        post :create, params: { app_id: app.id, link: attributes_for(:link, commodity_reference_id: commodity_reference.id) }
        expect(response).to redirect_to(app_commodity_reference_path(app,commodity_reference))
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid attributes" do
      it "does not save the new link in the database" do
        expect{
          post :create, params: { app_id: app.id, link: attributes_for(:invalid_link, commodity_reference_id: commodity_reference.id)}
        }.not_to change(Link, :count)
      end
    end
  end

  describe "PATCH #update" do

    context "with valid attributes" do
      it "updates the new link in the database" do
        link.url = "https://facebook.com"
        patch :update, params: { app_id: app.id, id: link.id, link: link.attributes }
        link.reload
        expect(link.url).to eq "https://facebook.com"
      end

      it "redirects to link's commodity#show path" do
        patch :update, params: { app_id: app.id, id: link.id, link: link.attributes }
        expect(response).to redirect_to(app_commodity_reference_path(app,link.commodity_reference))
        expect(flash[:notice]).to be_present
      end
    end

  end
end
