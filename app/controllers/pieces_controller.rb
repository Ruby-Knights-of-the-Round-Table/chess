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
      @piece.update_attributes(selected: @piece.selected)

      @board = @piece.game.pieces_as_array
      final_spots = @piece.piece_can_move_to(@board)
      render json: {piece: @piece, final_spots: final_spots}

      @game = @piece.game

      update_firebase(pieceId: @piece.id,
                      timeStamp: Time.now.to_s)
    end

    # redirect_to game_path(@piece.game_id)
  end

  def update
    @piece = Piece.find(params[:id])
    old_row = @piece.y_position
    old_cell = @piece.x_position
    row = params[:y_position]
    cell = params[:x_position]

    @board = @piece.game.pieces_as_array
    @piece.move_to!(row, cell) if @piece.piece_can_move_to(@board).include?([row.to_i, cell.to_i])

    @game = @piece.game

    render json: { piece: @piece,
                  turn: @piece.game.turn,
                  white_player_id: @piece.game.white_player_id,
                  black_player_id: @piece.game.black_player_id,
                  white_player_email: @piece.game.white_player.email,
                  black_player_email: @piece.game.black_player.email }

    update_firebase(pieceId: @piece.id,
                    y_select: old_row,
                    x_select: old_cell,
                    y_update: row,
                    x_update: cell,
                    timeStamp: Time.now.to_s)

    # redirect_to game_path(@piece.game_id)
  end


  private

  def piece_params
    params.require(:piece).permit(:selected, :x_position, :y_position, :captured_piece)
  end

  def update_firebase(data)
    base_uri = 'https://ruby-knights.firebaseio.com'
    firebase = Firebase::Client.new(base_uri)
    response = firebase.set("game#{@game.id}", data)
    # response = firebase.ref('pieces/').set("#{@piece.id}", data)
  end

end
