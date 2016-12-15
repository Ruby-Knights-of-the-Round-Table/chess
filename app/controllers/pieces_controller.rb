class PiecesController < ApplicationController
  before_action :authenticate_player!

  def select
    @piece = Piece.find(params[:id])
    if @piece.player_id == current_player.id && @piece.player_id == @piece.game.turn
      if @piece.selected != true then @piece.selected = true else @piece.selected = false end

      old_selected_piece = @piece.game.pieces.find_by(selected: true) || 0
      if old_selected_piece != 0
        old_selected_piece.selected = false
        old_selected_piece.update_attributes(selected: old_selected_piece.selected)
      end
    end

    @piece.update_attributes(selected: @piece.selected)
    redirect_to game_path(@piece.game_id)
  end

  def update
    @piece = Piece.find(params[:id])
    row = params[:y_position]
    cell = params[:x_position]
    @piece.move_to!(row, cell)
    redirect_to game_path(@piece.game_id)

  end


  private

  def piece_params
    params.require(:piece).permit(:selected, :x_position, :y_position)
  end


end
