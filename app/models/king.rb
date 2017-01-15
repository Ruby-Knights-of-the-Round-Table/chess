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
        enemy_pieces = self.game.pieces.where('player_id != ?', king.player_id).where(captured_piece: false)
        pieces_checking_king = []
        enemy_pieces.each do |current_piece|
            next if board[current_piece.y_position][current_piece.x_position] != current_piece.player_id # safe if board not equal to enemy id
            pieces_checking_king << current_piece if current_piece.piece_can_move_to(board).include?([king.y_position,king.x_position])
        end
        return pieces_checking_king
    end

    def if_king_move_in_check?(board,y,x)
        king = self
        enemy_pieces = self.game.pieces.where('player_id != ?', king.player_id).where(captured_piece: false)
        pieces_checking_king = []
        enemy_pieces.each do |current_piece|
            if current_piece.type == "Pawn"
                next if current_piece.x_position == x
                pawn_test_spots = []
                if current_piece.game.black_player_id == current_piece.player_id
                    pawn_test_spots = [[current_piece.y_position - 1,current_piece.x_position - 1],[current_piece.y_position - 1,current_piece.x_position + 1]]

                elsif current_piece.game.white_player_id == current_piece.player_id
                    pawn_test_spots = [[current_piece.y_position + 1,current_piece.x_position - 1],[current_piece.y_position + 1,current_piece.x_position + 1]]
                end
                pieces_checking_king << current_piece if pawn_test_spots.include?([y,x])
                next
            end
            pieces_checking_king << current_piece if current_piece.piece_can_move_to(board).include?([y,x])
        end
        return pieces_checking_king
    end

    def if_checkmate?(board)
        current_king = self
        pieces_attacking_king = current_king.if_check?(board)
        return false if pieces_attacking_king.length == 0

        current_king.game.pieces.where(player_id: current_king.player_id, captured_piece: false ).each do |piece|
          final_spots = piece.piece_can_move_to(board)
          # see if avail spaces can be moved to without there being a check

          if pieces_attacking_king.length > 0
              final_spots = piece.checkmoves(current_king, pieces_attacking_king, board)
          end
          final_spots = piece.dont_be_in_check(final_spots,current_king, board)
          return false if final_spots.length > 0
        end
        return true
    end
end
