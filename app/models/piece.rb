class Piece < ActiveRecord::Base
  belongs_to :game

  scope :selected, -> { where(selected: true) }

  def move_to!(new_y, new_x)
    self.update_attributes(y_position: new_y, x_position: new_x)
  end

  def not_obstructed(board,final_spots)
    # returns an array that selected piece can move to, given obstructions
    # vertical
    max = 7 - y_position
    min = y_position
    (-min..max).each do |i|
      if board[y_position+i][x_position] != nil && board[y_position+i][x_position] > 0 && (y_position+i) >= 0 && (y_position+i) <= 7

        if i > 0
          final_spots.delete_if { |coord| coord[0] > (y_position+i) && coord[1] == x_position }
          next
        elsif i < 0
          final_spots.delete_if { |coord| coord[0] < (y_position+i) && coord[1] == x_position }
        end

      end
    end


    #horizontal

    horizontalmax = 7 - x_position
    horizontalmin = x_position
    (-horizontalmin..horizontalmax).each do |i|
      if board[y_position][x_position+i] != nil && board[y_position][x_position+i] > 0 && (x_position+i) >= 0 && (x_position+i) <= 7

        if i > 0
          final_spots.delete_if { |coord| coord[0] == y_position && coord[1] > (x_position+i) }
          next
        elsif i < 0
          final_spots.delete_if { |coord| coord[0] == y_position && coord[1] < (x_position+i) }
        end

      end
    end



    # diagonal
    (-min..max).each do |i|
      if board[y_position+i][x_position+i] != nil && board[y_position+i][x_position+i] > 0 && (y_position+i) >= 0 && (y_position+i) <= 7 && (x_position+i) >= 0 && (x_position+i) <= 7
        if i > 0
          final_spots.delete_if { |coord| coord[0] > (y_position+i) && coord[1] > (x_position+i) }
          next
        elsif i < 0
          final_spots.delete_if { |coord| coord[0] < (y_position+i) && coord[1] < (x_position+i) }
        end

      end
    end
    (-min..max).each do |i|
      if board[y_position+i][x_position-i] != nil && board[y_position+i][x_position-i] > 0 && (y_position+i) >= 0 && (y_position+i) <= 7 && (x_position-i) >= 0 && (x_position-i) <= 7
        if i > 0
          final_spots.delete_if { |coord| coord[0] > (y_position+i) && coord[1] < (x_position-i) }
          next
        elsif i < 0
          final_spots.delete_if { |coord| coord[0] < (y_position+i) && coord[1] > (x_position-i) }
        end

      end
    end


    return final_spots

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

      if (possible_x >= 0 && possible_y >= 0 && possible_x <= 7 && possible_y <= 7) && board[possible_y][possible_x] == 0
        final_spots << [possible_y,possible_x]
      end
      # figure out if position is in bounds of board AND no pieces are there

    end

    return final_spots
  end


end
