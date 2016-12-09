class PiecesController < ApplicationController
  before_action :authenticate_player!

  def select
    @piece = Piece.find(params[:id])
    if @piece.selected != true then @piece.selected = true else @piece.selected = false end
    @piece.save
    # @game = @piece.game
    # @piece.selected ? @piece.update_attributes(selected: false) : @piece.update_attributes(selected: true)
    # @game.pieces.each do |piece|
    #   if piece != @piece
    #     piece.update_attributes(selected: false)
    #   end
    # end
    redirect_to game_path(@piece.game)
  end

  def update
    @piece = Piece.find(params[:id])
    row = params[:y_position]
    cell = params[:x_position]
    @piece.move_to!(row, cell)
    @piece.update_attributes(selected: false)
    redirect_to game_path(@piece.game)

  end


  private

  def piece_params
    params.require(:piece).permit(:selected, :x_position, :y_position)
  end


end
