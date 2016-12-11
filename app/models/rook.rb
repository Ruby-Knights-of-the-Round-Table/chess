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

        curr_x  = self.x_position
        curr_y = self.y_position
        rook_move_shape.each do |spot|
            x = spot[0]
            y = spot[1]
            possible_x = curr_x + x
            possible_y = curr_y + y

            final_spots << [possible_x,possible_y] if (possible_x >= 0 && possible_y >= 0 && possible_x <= 7 && possible_y <= 7 ) && board[possible_y][possible_x] === 0
            # figure out if position is in bounds of board AND no pieces are there
        end
        return final_spots
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
