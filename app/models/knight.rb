class Knight < Piece
    def color
        if Game.find(self.game_id).white_player_id === self.player_id then return "&#9816;" else return "&#9822;" end
    end

    def piece_can_move_to(board)
        final_spots = []
        knight_move_shape = [ [1,2], [-1,2], [1,-2], [-1,-2], [2,1], [-2,1], [2,-1], [-2,-1]  ]
        curr_x  = self.x_position
        curr_y = self.y_position
        knight_move_shape.each do |spot|
            x = spot[0]
            y = spot[1]
            possible_x = curr_x + x
            possible_y = curr_y + y

            final_spots << [possible_x,possible_y] if (possible_x >= 0 && possible_y >= 0 && possible_x <= 7 && possible_y <= 7 ) && board[possible_y][possible_x] === 0
            # figure out if position is in bounds of board AND no pieces are there
        end
        return final_spots
    end
    
end
