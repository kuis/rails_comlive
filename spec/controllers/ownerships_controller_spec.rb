require 'rails_helper'

RSpec.describe OwnershipsController, :type => :controller do
  context "As an authenticated user" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = create(:user)
      sign_in @user
    end

    describe "POST #create" do
      context "with valid attributes" do
        it "saves the new ownership in the database" do
          ownership_attrs = build(:ownership).attributes
          ownership_attrs["parent_id"] = "#{ownership_attrs["parent_type"]}-#{ownership_attrs["parent_id"]}"
          expect{
            post :create, params: { ownership: ownership_attrs }
           }.to change(Ownership, :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "does not save the new ownership in the database" do
          ownership_attrs = build(:invalid_ownership).attributes.symbolize_keys
          expect{
            post :create, params:  { ownership: ownership_attrs }
          }.not_to change(Ownership, :count)
        end
      end
    end
  end

  context "As an unauthenticated user" do
    describe "POST #create" do
      it "redirects to the signin page" do
        post :create, params:  { ownership: attributes_for(:ownership) }

        expect(response.status).to eq 302
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end
  end

end
