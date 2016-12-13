class Bishop < Piece
    def symbol
        if game.white_player_id == player_id then return "&#9815;" else return "&#9821;" end
    end

    def piece_can_move_to(board)
      final_spots = []
      bishop_move_shape = []

      #diagonal moves
      ((-7..7).to_a - [0]).each do |i|
        bishop_move_shape << [i,i]
        bishop_move_shape << [i,-i]
      end

      curr_y = self.y_position
      curr_x  = self.x_position
      bishop_move_shape.each do |spot|
           y = spot[0]
           x = spot[1]
           possible_y = curr_y + y
           possible_x = curr_x + x
           final_spots << [possible_y,possible_x] if (possible_x >= 0 && possible_y >= 0 && possible_x <= 7 && possible_y <= 7 ) && board[possible_y][possible_x] === 0
           # figure out if position is in bounds of board AND no pieces are there
      end
      return not_obstructed(board,final_spots)
    end
end
