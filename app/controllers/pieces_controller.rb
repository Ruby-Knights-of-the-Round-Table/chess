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
      @game = @piece.game

      current_king = @piece.game.pieces.find_by(player_id: current_player.id, type: "King" )
      pieces_attacking_king = current_king.if_check?(@board)

      # see if avail spaces can be moved to without there being a check


      if pieces_attacking_king.length > 0
          final_spots = @piece.checkmoves(current_king, pieces_attacking_king, @board)
      end
      p "xxxxxxx", final_spots
      final_spots = dont_be_in_check(final_spots,current_king)
      render json: {piece: @piece, final_spots: final_spots}
    else
      render json: 'failure'
    end
  end

  def update
    @piece = Piece.find(params[:id])
    old_row = @piece.y_position
    old_cell = @piece.x_position

    row = params[:y_position].to_i
    cell = params[:x_position].to_i

    @game = @piece.game
    if @piece.occupied_space?(row, cell) == true
      captured_piece = @game.pieces.where(y_position: row, x_position: cell, captured_piece: false).last
      y_captured = captured_piece.y_position
      x_captured = captured_piece.x_position
    end

    board = @piece.game.pieces_as_array

    if @piece.piece_can_move_to(board).include?([row.to_i, cell.to_i])
      @piece.move_to!(row, cell)
      Move.create(piece_id: @piece.id, x: cell, y: row, turn: @piece.game.turn + 1)
    end

    board = @piece.game.pieces_as_array
    turn = @piece.game.turn
    white_player_id = @piece.game.white_player_id
    black_player_id = @piece.game.black_player_id

    render json: { piece: @piece, turn: turn, white_player_id: white_player_id, black_player_id: black_player_id }

    update_firebase(pieceId: @piece.id,
                    y_select: old_row,
                    x_select: old_cell,
                    y_update: row,
                    x_update: cell,
                    timeStamp: Time.now.to_s,
                    turn: turn,
                    white_player_id: white_player_id,
                    black_player_id: black_player_id,
                    white_player_email: @piece.game.white_player.email,
                    black_player_email: @piece.game.black_player.email,
                    y_captured: y_captured,
                    x_captured: x_captured)
  end

  private

  # see if avail spaces can be moved to without there being a check
  def dont_be_in_check(final_spots,current_king)
      invalid = []
      final_spots.each do |spot|
         y = spot[0]
         x = spot[1]

         play_board = Marshal.load(Marshal.dump(@board))
         play_board[@piece.y_position][@piece.x_position] = 0
         play_board[y][x] = @piece.player_id

         if @piece.type == "King"
             invalid << spot if current_king.if_king_move_in_check?(play_board,y,x).length > 0
         else
             invalid << spot if current_king.if_check?(play_board).length > 0
         end
      end
      p "===========", final_spots, invalid
      return final_spots - invalid
  end

  def piece_params
    params.require(:piece).permit(:selected, :x_position, :y_position, :captured_piece)
  end

  def update_firebase(data)
    base_uri = 'https://ruby-knights.firebaseio.com'
    firebase = Firebase::Client.new(base_uri)
    response = firebase.update("game#{@game.id}", data)
  end

end
