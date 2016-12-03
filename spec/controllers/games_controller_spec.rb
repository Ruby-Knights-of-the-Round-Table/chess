require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#new" do
    it "should require players to be signed in" do
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

  describe "games#create" do
    it "should require players to be signed in" do
      post :create, game: { game_name: "Test Game"}
      expect(response).to redirect_to new_player_session_path
    end
    it "should allow players to successfully create a new game in the database" do
      player = FactoryGirl.create(:player)
      sign_in player

      game = FactoryGirl.create(:game)
      post :create, game_id: game.id, game: { game_name: "Test Game"}
      expect(response).to redirect_to game_path(assigns[:game])

      game = Game.last
      expect(game.game_name).to eq("Test Game")
      expect(game.white_player_id).to eq(player.id)
    end
  end

end
