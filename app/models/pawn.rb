class Pawn < Piece
    def symbol
        if game.white_player_id == player_id then return "&#9817;" else return "&#9823;" end
    end

    def piece_can_move_to(board)
      final_spots = []
      if game.white_player_id == player_id
        final_spots << [y_position+2, x_position] if y_position == 1
        final_spots << [y_position+1, x_position] if !occupied_space?(y_position+1, x_position)
        final_spots << [y_position+1, x_position+1] if occupied_space?(y_position+1,x_position+1)
        final_spots << [y_position+1, x_position-1] if occupied_space?(y_position+1,x_position-1)
      else
        final_spots << [y_position-2, x_position] if y_position == 6
        final_spots << [y_position-1, x_position] if !occupied_space?(y_position-1, x_position)
        final_spots << [y_position-1, x_position+1] if occupied_space?(y_position-1,x_position+1)
        final_spots << [y_position-1, x_position-1] if occupied_space?(y_position-1,x_position-1)
      end
      not_obstructed(board,final_spots)
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
