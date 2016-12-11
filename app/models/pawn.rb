class Pawn < Piece
    def symbol
        if self.game.white_player_id == self.player_id then return "&#9817;" else return "&#9823;" end
    end




    def piece_can_move_to(board)
        if self.game.white_player_id == self.player_id
            return [[self.x_position, self.y_position+1], [self.x_position, self.y_position+2]]if self.y_position == 1
            return [[self.x_position, self.y_position+1]]
        else
            return [[self.x_position, self.y_position-1], [self.x_position, self.y_position-2]]if self.y_position == 6
            return [[self.x_position, self.y_position-1]]

        end
    end
    
end
