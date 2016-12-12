class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: 'Player', foreign_key: 'white_player_id'
  belongs_to :black_player, class_name: 'Player', foreign_key: 'black_player_id'

  has_many :pieces

  scope :available, -> { where(black_player_id: nil) }

  def place_pieces_in_database(white_player, black_player)

    #white backrow pieces
    Rook.create(game_id: id, player_id: white_player_id, x_position: 0, y_position: 0)
    Rook.create(game_id: id, player_id: white_player_id, x_position: 7, y_position: 0)

    Knight.create(game_id: id, player_id: white_player_id, x_position: 1, y_position: 0)
    Knight.create(game_id: id, player_id: white_player_id, x_position: 6, y_position: 0)

    Bishop.create(game_id: id, player_id: white_player_id, x_position: 2, y_position: 0)
    Bishop.create(game_id: id, player_id: white_player_id, x_position: 5, y_position: 0)

    Queen.create(game_id: id, player_id: white_player_id, x_position: 3, y_position: 0)
    King.create(game_id: id, player_id: white_player_id, x_position: 4, y_position: 0)

    #black backrow pieces
    Rook.create(game_id: id, player_id: black_player_id, x_position: 0, y_position: 7)
    Rook.create(game_id: id, player_id: black_player_id, x_position: 7, y_position: 7)

    Knight.create(game_id: id, player_id: black_player_id, x_position: 1, y_position: 7)
    Knight.create(game_id: id, player_id: black_player_id, x_position: 6, y_position: 7)

    Bishop.create(game_id: id, player_id: black_player_id, x_position: 2, y_position: 7)
    Bishop.create(game_id: id, player_id: black_player_id, x_position: 5, y_position: 7)

    Queen.create(game_id: id, player_id: black_player_id, x_position: 3, y_position: 7)
    King.create(game_id: id, player_id: black_player_id, x_position: 4, y_position: 7)

    #white pawns
    (0..7).each do |i|
      Pawn.create(game_id: id, player_id: white_player_id, x_position: i, y_position: 1)
    end

    #black pawns
    (0..7).each do |i|
      Pawn.create(game_id: id, player_id: black_player_id, x_position: i, y_position: 6)
    end

  end

  #down the road, we will need a mcuh faster way to easily access piece data thats not through the database
  def pieces_as_array
    pieces = self.pieces
    piece_array = [
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0]
                  ]
    pieces.each do |piece|
      if piece.game.white_player_id === piece.player_id then color = piece.game.white_player_id  else color = piece.game.black_player_id  end
      piece_array[piece.y_position][piece.x_position] = color
    end
    return piece_array
  end

end
