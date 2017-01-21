class Pawn < Piece
    def symbol
        if game.white_player_id == player_id then return "&#9817;" else return "&#9823;" end
    end

    def piece_can_move_to(board)
      final_spots = []
      if game.white_player_id == player_id
        final_spots << [y_position+2, x_position] if y_position == 1 && !occupied_space?(y_position+2, x_position)
        final_spots << [y_position+1, x_position] if !occupied_space?(y_position+1, x_position)
        final_spots << [y_position+1, x_position+1] if occupied_space?(y_position+1,x_position+1) && board[y_position+1][x_position+1] != game.white_player_id
        final_spots << [y_position+1, x_position-1] if occupied_space?(y_position+1,x_position-1) && board[y_position+1][x_position-1] != game.white_player_id
      elsif game.black_player_id == player_id
        final_spots << [y_position-2, x_position] if y_position == 6 && !occupied_space?(y_position-2, x_position)
        final_spots << [y_position-1, x_position] if !occupied_space?(y_position-1, x_position)
        final_spots << [y_position-1, x_position+1] if occupied_space?(y_position-1,x_position+1) && board[y_position-1][x_position+1] != game.black_player_id
        final_spots << [y_position-1, x_position-1] if occupied_space?(y_position-1,x_position-1) && board[y_position-1][x_position-1] != game.black_player_id
      end
      not_obstructed(board,final_spots)
    end

    def promote!
      if self.type == "Pawn"
        self.update_attributes(type: "Queen")
      end
    end

    def move_to!(new_y, new_x)
      super(new_y, new_x)
      promote! if can_promote?
    end

    def can_promote?
      white_player? && y_position == 7 || black_player? && y_position == 0
    end
end
