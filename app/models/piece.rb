class Piece < ActiveRecord::Base
  belongs_to :game

  scope :selected, -> { where(selected: true) }

  def move_to!(new_x, new_y)
    self.update_attributes(x_position: new_x, y_position: new_y)
  end

  def symbol
    '?'
  end

  # placeholder only ... remove after all piece logic is completed
  def piece_can_move_to(board)
    final_spots = []
    piece_move_shape = [ [0,0] ] #need to change for each specific piece
    curr_y = self.y_position
    curr_x  = self.x_position
    piece_move_shape.each do |spot|
        y = spot[0]
        x = spot[1]
        possible_y = curr_y + y
        possible_x = curr_x + x

        final_spots << [possible_y,possible_x] if (possible_x >= 0 && possible_y >= 0 && possible_x <= 7 && possible_y <= 7 ) && board[possible_y][possible_x] === 0
        # figure out if position is in bounds of board AND no pieces are there
    end
    return final_spots
  end

end
