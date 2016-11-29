class GamesController < ApplicationController

    def index
        @games = Game.where( white_player_id: current_player.id ) + Game.where(black_player_id: current_player.id )
    end

    def new
        @game = Game.new
        # setting up fields
        @game.white_player_id = current_player.id
        @game.black_player_id = 9000 # <-- NEEDS a fix and be working with devise 2 player feature!
        @game.winner_id = 0
        @game.turn = 0
    end

    def show
        @game = Game.find(params[:id])
    end

    def create
        @game = Game.create(game_params)
        redirect_to( game_path(@game))
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
