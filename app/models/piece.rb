class Piece < ActiveRecord::Base
  belongs_to :game

  scope :selected, -> { where(selected: true) }

  def move_to!(new_x, new_y)
    self.update_attributes(x_position: new_x, y_position: new_y)
  end

  # In a world where every piece moves like knights!
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
            final_spots << [possible_x,possible_y] if (possible_x >= 0 && possible_y >= 0) && board[possible_y][possible_x] == 0
            # figure out if position is in bounds of board AND no pieces are there
        end
        return final_spots
    end

end
