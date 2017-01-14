class MovesController < ApplicationController
    def index
    end

    def show
      render json: Game.find(Piece.find(params[:id]).game_id).moves
    end
end
