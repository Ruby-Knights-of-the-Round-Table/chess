require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#new" do
    it "should require users to be signed in" do
      get :new
      expect(response).to redirect_to new_player_session_path
    end
    it "should successfully show the new game form" do
      player = FactoryGirl.create(:player)
      sign_in player
      get :new
      expect(response).to have_http_status(:success)
    end
  end
end
