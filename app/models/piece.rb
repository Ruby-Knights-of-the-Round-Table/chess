class Piece < ActiveRecord::Base
  belongs_to :game

  scope :selected, -> { where(selected: true) }

  def move_to!(new_y, new_x)
    Piece.transaction do
      self.x_position = new_x
      self.y_position = new_y
      self.selected = false
      self.save
      game.change_turn
    end
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

end
