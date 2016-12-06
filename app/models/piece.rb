class Piece < ActiveRecord::Base
  belongs_to :game

  scope :selected, -> { where(selected: true) }


end
