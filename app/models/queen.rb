class Queen < Piece
    def symbol
        if self.game.white_player_id == self.player_id then return "&#9813;" else return "&#9819;" end
    end

    def piece_can_move_to(board)
      final_spots = []
      queen_move_shape = []

      # horizontal, vertical, and diagonal moves
      ((-7..7).to_a - [0]).each do |i|
        queen_move_shape << [i,0]
        queen_move_shape << [0,i]
        queen_move_shape << [i,i]
        queen_move_shape << [i,-i]
      end

      curr_y = self.y_position
      curr_x  = self.x_position
      queen_move_shape.each do |spot|
        y = spot[0]
        x = spot[1]
        possible_y = curr_y + y
        possible_x = curr_x + x

        # figure out if position is in bounds of board AND no pieces are there
        if (possible_x >= 0 && possible_y >= 0 && possible_x <= 7 && possible_y <= 7 ) && board[possible_y][possible_x] == 0
           final_spots << [possible_y,possible_x]
        end
      end

        # OBSTRUCTION: figure out if selected piece is obstructed
        # vertical below
          max = 7 - curr_y
          (1..max).each do |i|   # min..max exclude 0

            # figure out if obstructions exist
            if board[curr_y+i][curr_x] > 0 && (curr_y+i) >= 0 && (curr_y+i) <= 7

              # remove all final spots where y value is greater than y value of obstruction
              final_spots.delete_if { |coord| coord[0] > (curr_y+i) && coord[1] == curr_x }
            end
          end

          # vertical above
            min = curr_y - 0
            (-5..-1).each do |i|

              # figure out if obstructions exist
              if board[curr_y+i][curr_x] > 0 && (curr_y+i) >= 0 && (curr_y+i) <= 7

                # remove all final spots where y value is less than y value of obstruction
                final_spots.delete_if { |coord| coord[0] < (curr_y+i) && coord[1] == curr_x }
              end
            end

      return final_spots
    end

end
