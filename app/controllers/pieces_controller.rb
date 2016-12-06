class PiecesController < ApplicationController
  before_action :authenticate_player!

  def select
    @piece = Piece.find(params[:id])
    @game = @piece.game

    if @piece.player_id == current_player.id
      @piece.selected ? @piece.update_attributes(selected: false) : @piece.update_attributes(selected: true)

      @game.pieces.each do |piece|
        if piece != @piece && piece.game_id == @game.id
          piece.update_attributes(selected: false)
        end
      end
    end

    redirect_to game_path(@game)
  end

  private

  def piece_params
    params.require(:piece).permit(:selected, :x_position, :y_position)
  end

end
