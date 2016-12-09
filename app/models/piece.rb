class Piece < ActiveRecord::Base
  belongs_to :game

  scope :selected, -> { where(selected: true) }

  def move_to!(new_x, new_y)
    self.update_attributes(x_position: new_x, y_position: new_y)
  end

end
