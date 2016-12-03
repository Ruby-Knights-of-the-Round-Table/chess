class GamesController < ApplicationController
    before_action :authenticate_player!

    def index
        @games = Game.where(white_player_id: current_player.id) + Game.where(black_player_id: current_player.id)
        @open_games = Game.where(black_player_id: nil)
    end

    def new
        @game = Game.new
    end

    def show
        @game = Game.find(params[:id])
    end

    def create
        @game = Game.create(game_params)
        @game.white_player_id = current_player.id
        @game.save
        @game.place_pieces_in_database(current_player.id, nil)
        redirect_to( game_path(@game) )
    end

    def destroy
        @game = Game.find(params[:id])
        @game.destroy
        redirect_to(games_path)
    end


    private

    def game_params
      params.require(:game).permit(:game_name, :white_player_id, :black_player_id, :winner_id, :turn  )
    end
end
