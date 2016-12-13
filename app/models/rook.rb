class Rook < Piece
  def symbol
      if self.game.white_player_id == self.player_id then return "&#9814;" else return "&#9820;" end
  end

  def piece_can_move_to(board)
      final_spots = []
      rook_move_shape = []

      #horizontal and vertical
      ((-7..7).to_a - [0]).each do |i|
        rook_move_shape << [0,i]
        rook_move_shape << [i,0]
      end

      curr_y = self.y_position
      curr_x  = self.x_position
      rook_move_shape.each do |spot|
           y = spot[0]
           x = spot[1]
           possible_y = curr_y + y
           possible_x = curr_x + x
           #figure out if position is in bounds of board AND no pieces are there
           final_spots << [possible_y,possible_x] if (possible_x >= 0 && possible_y >= 0 && possible_x <= 7 && possible_y <= 7 ) && board[possible_y][possible_x] === 0
      end
      return is_obstructed?(curr_y,curr_x,board,final_spots)
  end
end
