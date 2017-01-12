class King < Piece
    def symbol
        if game.white_player_id == player_id then return "&#9812;" else return "&#9818;" end
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


            final_spots << [possible_y,possible_x] if (possible_x >= 0 && possible_y >= 0 && possible_x <= 7 && possible_y <= 7 ) && board[possible_y][possible_x] != self.player_id
            # figure out if position is in bounds of board AND no pieces are there
        end
        return not_obstructed(board,final_spots) 
    end

    def if_check?(board)
        king = self
        enemy_pieces = self.game.pieces.where('player_id != ?', king.player_id)
        pieces_checking_king = []
        enemy_pieces.each do |current_piece|
            next if board[current_piece.y_position][current_piece.x_position] != current_piece.player_id
            pieces_checking_king << current_piece if current_piece.piece_can_move_to(board).include?([king.y_position,king.x_position])
        end
        return pieces_checking_king
    end

    def if_king_move_in_check?(board,y,x)
        king = self
        enemy_pieces = self.game.pieces.where('player_id != ?', king.player_id)
        pieces_checking_king = []
        enemy_pieces.each do |current_piece|
            next if board[current_piece.y_position][current_piece.x_position] != current_piece.player_id
            pieces_checking_king << current_piece if current_piece.piece_can_move_to(board).include?([y,x])
        end
        return pieces_checking_king
    end

end
