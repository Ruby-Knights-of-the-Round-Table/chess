class King < Piece
    def symbol
        if self.game.white_player_id == self.player_id then return "&#9812;" else return "&#9818;" end
    end

    def piece_can_move_to(board)
        final_spots = []
        king_move_shape = [ [1,1], [-1,1], [1,-1], [-1,-1], [0,1], [0,-1], [1,0], [-1,0] ]
        curr_y = self.y_position
        curr_x  = self.x_position
        king_move_shape.each do |spot|
            y = spot[0]
            x = spot[1]
            possible_y = curr_y + y
            possible_x = curr_x + x

            final_spots << [possible_y,possible_x] if (possible_x >= 0 && possible_y >= 0 && possible_x <= 7 && possible_y <= 7 ) && board[possible_y][possible_x] === 0
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
