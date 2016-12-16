class GamesController < ApplicationController
    before_action :authenticate_player!
    def index
        @games = Game.where(white_player_id: current_player.id) + Game.where(black_player_id: current_player.id)
        @all_games = Game.all
    end

    def new
        @game = Game.new
    end

    def show
        @game = Game.find(params[:id])
        @board = @game.pieces_as_array
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

    def join
        @game = Game.find(params[:id])
        if @game.white_player_id != nil && current_player.id != @game.white_player_id
          @game.black_player_id = current_player.id
          @game.turn = @game.white_player_id
          @game.save
          @game.pieces.where(player_id: nil).update_all(player_id: current_player.id)
          redirect_to(game_path(@game))
        end
    end


    private

    def game_params
      params.require(:game).permit(:game_name, :white_player_id, :black_player_id, :winner_id, :turn  )
    end
end
