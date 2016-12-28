class Pawn < Piece
    def symbol
        if game.white_player_id == player_id then return "&#9817;" else return "&#9823;" end
    end

    def piece_can_move_to(board)
      final_spots = []

      if occupied_space?(y_position+1,x_position+1) || occupied_space?(y_position+1,x_position-1)
        pawn_capture_shape = [ [1,1], [1,-1] ]
        curr_y = self.y_position
        curr_x  = self.x_position
        pawn_capture_shape.each do |spot|
          y = spot[0]
          x = spot[1]
          possible_y = curr_y + y
          possible_x = curr_x + x
          final_spots << [possible_y,possible_x] if (possible_x >= 0 && possible_y >= 0 && possible_x <= 7 && possible_y <= 7 ) && board[possible_y][possible_x] != self.player_id
        end
        return not_obstructed(board,final_spots)

      elsif occupied_space?(y_position-1,x_position+1) || occupied_space?(y_position-1,x_position-1)
          pawn_capture_shape = [ [-1,1], [-1,-1] ]
          curr_y = self.y_position
          curr_x  = self.x_position
          pawn_capture_shape.each do |spot|
            y = spot[0]
            x = spot[1]
            possible_y = curr_y + y
            possible_x = curr_x + x
            final_spots << [possible_y,possible_x] if (possible_x >= 0 && possible_y >= 0 && possible_x <= 7 && possible_y <= 7 ) && board[possible_y][possible_x] != self.player_id
          end
          return not_obstructed(board,final_spots)


      elsif game.white_player_id == player_id
        final_spots << [y_position+2, x_position] if y_position == 1
        final_spots << [y_position+1, x_position]
        return not_obstructed(board,final_spots)

      else
        final_spots << [y_position-2, x_position] if y_position == 6
        final_spots << [y_position-1, x_position]
        return not_obstructed(board,final_spots)

      end


    end


    # def piece_can_move_to(board)

        # piece logic goes inside this method

        # you are already given a 'board' which is a 2D array. It mimics the actual database board,
        # 0 represents an empty space and the particular number matchs such that:
        # board_start = [[1, 1, 1, 1, 1, 1, 1, 1],
        #                [1, 1, 1, 1, 1, 1, 1, 1],
        #                [0, 0, 0, 0, 0, 0, 0, 0],
        #                [0, 0, 0, 0, 0, 0, 0, 0],
        #                [0, 0, 0, 0, 0, 0, 0, 0],
        #                [0, 0, 0, 0, 0, 0, 0, 0],
        #                [2, 2, 2, 2, 2, 2, 2, 2],
        #                [2, 2, 2, 2, 2, 2, 2, 2]]
        # 1 would be the white player and 2 would be the black player,
        # but these numbers are suppost to be the same as their "player_id".
        # so if black had a player_id of 5, then where you see 2's, they would be 5's
        # don't worry



        # 'piece_can_move_to' should RETURN an array of cordinates, [x,y] ,
        # such that they match this piece's logic: [[3,4] ,[5,7], [0,1]...]

    # end
end
