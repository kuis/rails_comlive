require 'rails_helper'

RSpec.describe HscodeHeadingsController, :type => :controller do
  context "As an authenticated user" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = create(:user)
      @live_animals = create(:hscode_chapter)
      @edible_meat_offal = create(:hscode_chapter)
      sign_in @user
    end

    describe "GET #index" do
      context "Given a hscode chapter id" do
        it "returns hscode headings belonging to the hscode chapter" do
          horses = create(:hscode_heading, hscode_chapter: @live_animals)
          bovine_animals = create(:hscode_heading, hscode_chapter: @live_animals)
          swine = create(:hscode_heading, hscode_chapter: @edible_meat_offal)
          sheep_and_goat = create(:hscode_heading, hscode_chapter: @edible_meat_offal)

          get :index, params: { hscode_chapter_id: @live_animals.id }

          results = JSON.parse(response.body)

          expected_results = [horses,bovine_animals].map{|r| {'id' => r.id, 'description' => r.description} }
          ommitted_results = [swine,sheep_and_goat].map{|r| {'id' => r.id, 'description' => r.description} }

          expect(results).to match_array(expected_results)
          expect(results.count).to eq 2
          expect(results).not_to include(ommitted_results)
        end
      end
    end
  end

  context "As an unauthenticated user" do
    describe "GET #index" do
      it "redirects to the signin page" do
        get :index

        expect(response.status).to eq 302
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end
  end
end
