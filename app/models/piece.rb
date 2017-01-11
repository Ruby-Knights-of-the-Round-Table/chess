class Piece < ActiveRecord::Base
  belongs_to :game

  scope :selected, -> { where(selected: true) }
  scope :onboard, -> { where(captured_piece: false) }

  # def captured!
  #   self.update(captured_piece: true)
  #   self.delete
  # end
  #
  # def capture_piece(y, x)
  #   return false unless game.occupied_space?(y, x)
  #   self.onboard.where(y_position: y, x_position: x).first.captured!
  # end

  def occupied_space?(y, x)
      pieces = self.game.pieces
      pieces.onboard.where(y_position: y, x_position: x).any?
  end

  def white_player?
      game.white_player_id == player_id
  end
  def black_player?
      game.black_player_id == player_id
  end

  def move_to!(new_y, new_x)
      if occupied_space?(new_y,new_x) == true
        piece = self.game.pieces.find_by(y_position: new_y, x_position: new_x, captured_piece: false)
        # piece.delete
        piece.transaction do
          piece.captured_piece = true
          piece.game.pieces_as_array
          piece.save
        end
      end
      Piece.transaction do
        self.x_position = new_x
        self.y_position = new_y
        self.selected = false
        self.game.pieces_as_array        
        self.save
      end
      game.change_turn
  end

  def not_obstructed(board,final_spots)
    # returns an array that selected piece can move to, given obstructions
    # vertical
    max = 7 - y_position
    min = y_position
    (-min..max).each do |i|
      if board[y_position+i][x_position] != nil && board[y_position+i][x_position] > 0 && (y_position+i) >= 0 && (y_position+i) <= 7
        if i > 0
          final_spots.delete_if { |coord| coord[0] > (y_position+i) && coord[1] == x_position }
          next
        elsif i < 0
          final_spots.delete_if { |coord| coord[0] < (y_position+i) && coord[1] == x_position }
        end
      end
    end

    #horizontal
    horizontalmax = 7 - x_position
    horizontalmin = x_position
    (-horizontalmin..horizontalmax).each do |i|
      if board[y_position][x_position+i] != nil && board[y_position][x_position+i] > 0 && (x_position+i) >= 0 && (x_position+i) <= 7
        if i > 0
          final_spots.delete_if { |coord| coord[0] == y_position && coord[1] > (x_position+i) }
          next
        elsif i < 0
          final_spots.delete_if { |coord| coord[0] == y_position && coord[1] < (x_position+i) }
        end
      end
    end

    # diagonal
    (-min..max).each do |i|
      if board[y_position+i][x_position+i] != nil && board[y_position+i][x_position+i] > 0 && (y_position+i) >= 0 && (y_position+i) <= 7 && (x_position+i) >= 0 && (x_position+i) <= 7
        if i > 0
          final_spots.delete_if { |coord| coord[0] > (y_position+i) && coord[1] > (x_position+i) }
          next
        elsif i < 0
          final_spots.delete_if { |coord| coord[0] < (y_position+i) && coord[1] < (x_position+i) }
        end
      end
    end
    (-min..max).each do |i|
      if board[y_position+i][x_position-i] != nil && board[y_position+i][x_position-i] > 0 && (y_position+i) >= 0 && (y_position+i) <= 7 && (x_position-i) >= 0 && (x_position-i) <= 7
        if i > 0
          final_spots.delete_if { |coord| coord[0] > (y_position+i) && coord[1] < (x_position-i) }
          next
        elsif i < 0
          final_spots.delete_if { |coord| coord[0] < (y_position+i) && coord[1] > (x_position-i) }
        end
      end
    end
    return final_spots
  end

   # prevent_check_moves ( TODO )
    #    from the possible moves, see if this move can undo the check
    #    if if_check? is null, then end this program

  def checkmoves(king, attacking_pieces, board )
    if self == king
      enemy_pieces = self.game.pieces.where('player_id != ?', king.player_id)
      king_moves = king.piece_can_move_to(board)
      enemy_pieces.each do |enemy_piece|
        king_moves -= enemy_piece.piece_can_move_to(board)
      end
      return king_moves
    end

    return [] if attacking_pieces.length > 1 # can't defend from two attacking pieces unless king is moved

    current_piece = self
    current_piece_moves_avail =  current_piece.piece_can_move_to(board)
    enemy_piece = attacking_pieces[0] # since only one piece is attacking, we should rename this
    current_piece_moves_avail = current_piece_moves_avail & (enemy_piece.piece_can_move_to(board) + [[enemy_piece.y_position,enemy_piece.x_position]])# finding the squares these pieces can both move to

    prevent_check_moves = []

    current_piece_moves_avail.each do |square|
      y = square[0]
      x = square[1]
      play_board = Marshal.load(Marshal.dump(board))
      play_board[self.y_position][x_position] = 0
      play_board[y][x] = self.player_id
      # enemy piece should have x,y such that board[y][x] should equal to enemy player.id
      if play_board[enemy_piece.y_position][enemy_piece.x_position] == self.player_id
        prevent_check_moves << square
        next
      end
      prevent_check_moves << square if !enemy_piece.piece_can_move_to(play_board).include?([king.y_position,king.x_position])
    end
    return prevent_check_moves


  end

  # def capturing_move(y, x)
  #   captured_piece = piece.not_obstructed(board, final_spots)
  #   captured_piece && captured_piece.player_id != player_id
  # end
  #
  # def capture(piece, new_y, new_x)
  #   if piece.player_id != player_id
  #     piece.move_to!(new_y, new_x)
  #   end
  # end


end
