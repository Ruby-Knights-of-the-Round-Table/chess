require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  describe "games#index action" do
    it "should successfully show the page" do
      player = FactoryGirl.create(:player)
      sign_in player
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "games#new" do
    it "should require players to be signed in to see the new game form" do
      get :new
      expect(response).to redirect_to new_player_session_path
    end
    it "should successfully show the new game form if player is signed in" do
      player = FactoryGirl.create(:player)
      sign_in player
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "games#show" do
    it "should successfully show the game page if player is signed in" do
      player = FactoryGirl.create(:player)
      sign_in player
      game = FactoryGirl.create(:game)
      get :show, id: game.id
      expect(response).to have_http_status(:success)
    end
  end

  describe "games#create" do
    it "should require players to be signed in to create a game" do
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

  describe "games#destroy action" do
    it "shouldn't let players who aren't signed in delete a game" do
      game = FactoryGirl.create(:game)
      delete :destroy, id: game.id
      expect(response).to redirect_to new_player_session_path
    end
    it "should let players delete a game" do
      game = FactoryGirl.create(:game)
      player = FactoryGirl.create(:player)
      sign_in player
      delete :destroy, id: game.id
      expect(response).to redirect_to games_path
      game = Game.find_by_id(game.id)
      expect(game).to eq nil
    end
  end

end
