class Queen < Piece
    def symbol
        if self.game.white_player_id == self.player_id then return "&#9813;" else return "&#9819;" end
    end

    def piece_can_move_to(board)
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

    end
    
end
