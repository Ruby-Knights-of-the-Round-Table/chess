class Piece < ActiveRecord::Base
  belongs_to :game

  scope :selected, -> { where(selected: true) }
  scope :onboard, -> { where(captured_piece: false) }

  def captured!
    self.update(captured_piece: true)
    self.delete
  end

  def capture_piece(y, x)
    return false unless game.occupied_space?(y, x)
    self.onboard.where(y_position: y, x_position: x).first.captured!
  end

  def occupied_space?(y, x)
      pieces = self.game.pieces
      pieces.onboard.where(y_position: y, x_position: x).any?
  end


  def move_to!(new_y, new_x)
      if occupied_space?(new_y,new_x) == true
        piece = self.game.pieces.find_by( y_position: new_y, x_position: new_x)
        piece.delete

        self.x_position = new_x
        self.y_position = new_y
        self.selected = false
        self.save
        game.change_turn
      else
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
    p "#{final_spots}"
    return final_spots
  end



  # def capturing_move(y, x)
  #   captured_piece = piece.not_obstructed(board, final_spots)
  #   captured_piece && captured_piece.player_id != player_id
  # end
  #
  # def capture(piece, new_y, new_x)
  #   if piece.player_id != player_id
  #     piece.move_to!(new_y, new_x)
  #   end
  # end


end
